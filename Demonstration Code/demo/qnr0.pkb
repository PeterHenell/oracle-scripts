CREATE OR REPLACE PACKAGE BODY Qnr
IS
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
      c_max_context   CONSTANT PLS_INTEGER := 8;
      l_context                PLS_INTEGER := 0;
      l_resolved               BOOLEAN     := FALSE;
   BEGIN
      WHILE (NOT l_resolved AND l_context <= c_max_context)
      LOOP
         BEGIN
            DBMS_UTILITY.name_resolve (NAME
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
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (   'Qnxo_Name_Resolve cannot resolve "'
                               || NAME
                               || '"'
                              );
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
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

      -- Collection to hold object type names for type numbers
      TYPE names_tt IS TABLE OF ALL_OBJECTS.object_type%TYPE
         INDEX BY BINARY_INTEGER;

      names_t         names_tt;

      PROCEDURE initialize
      IS
      BEGIN
         names_t (c_table_type) := 'Table';
         names_t (c_table_type) := 'View';
         names_t (c_synonym_type) := 'Synonym';
         names_t (c_procedure_type) := 'Procedure';
         names_t (c_function_type) := 'Function';
         names_t (c_package_type) := 'Package';
      END initialize;

      FUNCTION name_for_type (type_in IN PLS_INTEGER)
         RETURN VARCHAR2
      IS
      BEGIN
         RETURN names_t (type_in);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN type_in;
      END name_for_type;
   BEGIN
      initialize;
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
      l_synonym   ALL_SYNONYMS%ROWTYPE;
   BEGIN
      SELECT *
        INTO l_synonym
        FROM ALL_SYNONYMS
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
      l_synonym            ALL_SYNONYMS%ROWTYPE;
      started_as_synonym   BOOLEAN                DEFAULT FALSE;
      still_a_synonym      BOOLEAN;

      PROCEDURE parse_name
      IS
         c         ALL_OBJECTS.object_name%TYPE;
         dblink    ALL_OBJECTS.object_name%TYPE;
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
         owner_in     IN       ALL_SYNONYMS.owner%TYPE
        ,NAME_IN      IN       ALL_SYNONYMS.synonym_name%TYPE
        ,syn_out      OUT      ALL_SYNONYMS%ROWTYPE
        ,is_syn_out   OUT      BOOLEAN
      )
      IS
         l_synonym   ALL_SYNONYMS%ROWTYPE;
      BEGIN
         SELECT *
           INTO syn_out
           FROM ALL_SYNONYMS
          WHERE owner = owner_in AND synonym_name = NAME_IN;

         is_syn_out := TRUE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            -- Now try the same thing with PUBLIC as owner.
            BEGIN
               SELECT *
                 INTO syn_out
                 FROM ALL_SYNONYMS
                WHERE owner = 'PUBLIC' AND synonym_name = NAME_IN;

               is_syn_out := TRUE;
            EXCEPTION
               WHEN OTHERS
               THEN
                  -- We have gone as far as we can go.
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
END Qnr;
/
