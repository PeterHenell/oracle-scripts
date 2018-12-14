CREATE OR REPLACE PACKAGE BODY qnr
IS
   -- Collection to hold object type names for type numbers
   TYPE names_tt IS TABLE OF all_objects.object_type%TYPE
      INDEX BY BINARY_INTEGER;

   g_names   names_tt;

   PROCEDURE name_resolve (
      NAME            IN       VARCHAR2
     ,SCHEMA          OUT      VARCHAR2
     ,part1           OUT      VARCHAR2
     ,part2           OUT      VARCHAR2
     ,dblink          OUT      VARCHAR2
     ,part1_type      OUT      NUMBER
     ,object_number   OUT      NUMBER
   )
   IS
      PROCEDURE resolve_in_loop (NAME_IN IN VARCHAR2)
      IS
         -- Maximum context allowed by NAME_RESOLVE
         c_max_context   CONSTANT PLS_INTEGER := 8;
         -- Test context value
         l_context                PLS_INTEGER := 0;
         --
         l_resolved               BOOLEAN     := FALSE;
      BEGIN
         /* Break down the name into its components */
         WHILE (NOT l_resolved AND l_context <= c_max_context)
         LOOP
            BEGIN
               DBMS_UTILITY.name_resolve (NAME_IN
                                         ,l_context
                                         ,SCHEMA
                                         ,part1
                                         ,part2
                                         ,dblink
                                         ,part1_type
                                         ,object_number
                                         );
               l_resolved := TRUE;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_context := l_context + 1;
            END;
         END LOOP;
      END resolve_in_loop;

      PROCEDURE try_as_synonym (NAME_IN IN VARCHAR2)
      IS
         l_schema   all_objects.owner%TYPE;
         l_name     all_objects.object_name%TYPE;
      BEGIN
         -- Try to resolve as synonym.
         synonym_resolve (NAME_IN, l_schema, l_name);

         IF l_name IS NOT NULL
         THEN
            resolve_in_loop (l_schema || '.' || l_name);
         END IF;
      END try_as_synonym;
   BEGIN
      resolve_in_loop (NAME);

      IF object_number IS NULL
      THEN
         try_as_synonym (NAME);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         try_as_synonym (NAME);
   END name_resolve;

   FUNCTION name_resolve (NAME IN VARCHAR2)
      RETURN name_resolve_rt
   IS
      l_name_resolve   name_resolve_rt;
   BEGIN
      name_resolve (NAME               => NAME
                   ,SCHEMA             => l_name_resolve.SCHEMA
                   ,part1              => l_name_resolve.part1
                   ,part2              => l_name_resolve.part2
                   ,dblink             => l_name_resolve.dblink
                   ,part1_type         => l_name_resolve.part1_type
                   ,object_number      => l_name_resolve.object_number
                   );
      RETURN l_name_resolve;
   END name_resolve;

   PROCEDURE show (NAME_IN IN VARCHAR2)
   IS
      --
      -- Variables to hold components of the name.
      sch             VARCHAR2 (100);
      part1           VARCHAR2 (100);
      part2           VARCHAR2 (100);
      dblink          VARCHAR2 (100);
      part1_type      NUMBER;
      object_number   NUMBER;
      --
      --
      l_string        VARCHAR2 (1000);
   BEGIN
      name_resolve (NAME_IN
                   ,sch
                   ,part1
                   ,part2
                   ,dblink
                   ,part1_type
                   ,object_number
                   );

      -- If the object number is NULL, name resolution failed.
      IF object_number IS NULL
      THEN
         l_string :=
                 'Name "' || NAME_IN || '" does not identify a valid object.';
      ELSE
         l_string := NAME_IN || ' ==> owner: ' || sch;

         IF part1 IS NOT NULL
         THEN
            l_string :=
                l_string || ' ' || name_for_type (part1_type) || ': '
                || part1;

            IF part2 IS NOT NULL
            THEN
               l_string := l_string || ' Name: ' || part2;
            END IF;
         ELSE
            l_string :=
                l_string || ' ' || name_for_type (part1_type) || ': '
                || part2;
         END IF;

         IF dblink IS NOT NULL
         THEN
            l_string := l_string || ' Database Link:' || dblink;
         END IF;
      END IF;

      DBMS_OUTPUT.put_line (l_string);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('   QNR Error resolving "' || NAME_IN);
         DBMS_OUTPUT.put_line ('   ' || DBMS_UTILITY.format_error_stack);
   END show;

   PROCEDURE show_synonym (owner_in IN VARCHAR2, NAME_IN IN VARCHAR2)
   IS
      l_synonym   all_synonyms%ROWTYPE;
   BEGIN
      SELECT *
        INTO l_synonym
        FROM all_synonyms
       WHERE owner = UPPER (owner_in) AND synonym_name = UPPER (NAME_IN);

      DBMS_OUTPUT.put_line ('Synonym "' || NAME_IN || '" is defined as:');
      DBMS_OUTPUT.put_line ('   Owner: ' || l_synonym.owner);
      DBMS_OUTPUT.put_line ('   Synonym name: ' || l_synonym.synonym_name);
      DBMS_OUTPUT.put_line ('   Table owner: ' || l_synonym.table_owner);
      DBMS_OUTPUT.put_line ('   Table name: ' || l_synonym.table_name);
      DBMS_OUTPUT.put_line ('   Database link: ' || l_synonym.db_link);
      DBMS_OUTPUT.put_line ('');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line (   '"'
                               || owner_in
                               || '.'
                               || NAME_IN
                               || '" does not identify a synonym.'
                              );
         DBMS_OUTPUT.put_line ('');
   END show_synonym;

   PROCEDURE synonym_resolve (
      NAME_IN           IN       VARCHAR2
     ,schema_out        OUT      VARCHAR2
     ,object_name_out   OUT      VARCHAR2
   )
   IS
      l_synonym            all_synonyms%ROWTYPE;
      started_as_synonym   BOOLEAN                DEFAULT FALSE;
      still_a_synonym      BOOLEAN;

      PROCEDURE parse_name
      IS
         c         all_objects.object_name%TYPE;
         dblink    all_objects.object_name%TYPE;
         nextpos   BINARY_INTEGER;
      BEGIN
         DBMS_UTILITY.name_tokenize (NAME         => NAME_IN
                                    ,a            => l_synonym.owner
                                    ,b            => l_synonym.synonym_name
                                    ,c            => c
                                    ,dblink       => dblink
                                    ,nextpos      => nextpos
                                    );

         IF l_synonym.synonym_name IS NULL
         THEN
            -- No owner specified, so name is passed back in "a". Rearrange the items.
            l_synonym.synonym_name := l_synonym.owner;
            l_synonym.owner := USER;
         END IF;
      END parse_name;

      PROCEDURE get_synonym_info (
         owner_in     IN       all_synonyms.owner%TYPE
        ,NAME_IN      IN       all_synonyms.synonym_name%TYPE
        ,syn_out      OUT      all_synonyms%ROWTYPE
        ,is_syn_out   OUT      BOOLEAN
      )
      IS
         l_synonym   all_synonyms%ROWTYPE;

         PROCEDURE retrieve_one_synonym (schema_in IN VARCHAR2)
         IS
         BEGIN
            SELECT *
              INTO syn_out
              FROM all_synonyms
             WHERE owner = schema_in AND synonym_name = NAME_IN;

            is_syn_out := TRUE;
         END retrieve_one_synonym;
      BEGIN
         retrieve_one_synonym (schema_in => owner_in);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            -- Now try the same thing with PUBLIC as owner.
            BEGIN
               retrieve_one_synonym (schema_in => 'PUBLIC');
            EXCEPTION
               WHEN OTHERS
               THEN
                  -- We have gone as far as we can go, so return same values.
                  syn_out.table_owner := owner_in;
                  syn_out.table_name := NAME_IN;
                  is_syn_out := FALSE;
            END;
      END get_synonym_info;
   BEGIN
      parse_name;

      LOOP
         get_synonym_info (l_synonym.owner
                          ,l_synonym.synonym_name
                          ,l_synonym
                          ,still_a_synonym
                          );

         IF still_a_synonym
         THEN
            started_as_synonym := TRUE;
            --
            -- Now see if we have a recursive synonym definition
            l_synonym.owner := l_synonym.table_owner;
            l_synonym.synonym_name := l_synonym.table_name;
         ELSE
            -- All done, pass back values if we have anything.
            IF started_as_synonym
            THEN
               schema_out := l_synonym.table_owner;
               object_name_out := l_synonym.table_name;
            END IF;

            EXIT;
         END IF;
      END LOOP;
   END synonym_resolve;

   PROCEDURE initialize_types
   IS
   BEGIN
      g_names (c_table_type) := 'Table';
      g_names (c_view_type) := 'View';
      g_names (c_synonym_type) := 'Synonym';
      g_names (c_procedure_type) := 'Procedure';
      g_names (c_function_type) := 'Function';
      g_names (c_package_type) := 'Package';
      g_names (c_object_type) := 'Object Type';
   END initialize_types;

   FUNCTION name_for_type (type_in IN PLS_INTEGER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_names (type_in);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN type_in;
   END name_for_type;
BEGIN
   initialize_types;
END qnr;
/