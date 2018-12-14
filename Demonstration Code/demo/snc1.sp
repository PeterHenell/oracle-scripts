CREATE OR REPLACE PROCEDURE snc (NAME_IN IN VARCHAR2, objtype_in IN PLS_INTEGER)
IS
   /* variables to hold components of the name */
   sch             VARCHAR2 (100);
   part1           VARCHAR2 (100);
   part2           VARCHAR2 (100);
   dblink          VARCHAR2 (100);
   part1_type      NUMBER;
   object_number   NUMBER;
   --
   l_resolved boolean;

   /*--------------------- Local Module -----------------------*/
   FUNCTION object_type (type_in IN INTEGER)
      RETURN VARCHAR2
   /* Return name for integer type */
   IS
      table_type       CONSTANT INTEGER       := 2;
      view_type        CONSTANT INTEGER       := 4;
      synonym_type     CONSTANT INTEGER       := 5;
      procedure_type   CONSTANT INTEGER       := 7;
      function_type    CONSTANT INTEGER       := 8;
      package_type     CONSTANT INTEGER       := 9;
      object_type      CONSTANT INTEGER       := 13;
      retval                    VARCHAR2 (20);
   BEGIN
      IF type_in = synonym_type
      THEN
         retval := 'Synonym';
      ELSIF type_in = procedure_type
      THEN
         retval := 'Procedure';
      ELSIF type_in = function_type
      THEN
         retval := 'Function';
      ELSIF type_in = package_type
      THEN
         retval := 'Package';
      ELSIF type_in = table_type
      THEN
         retval := 'Table';
      ELSIF type_in = view_type
      THEN
         retval := 'View';
      ELSIF type_in = object_type
      THEN
         retval := 'Object';
      ELSE
         retval := TO_CHAR (type_in);
      END IF;

      RETURN retval;
   END;

   PROCEDURE try_resolve (NAME_IN IN VARCHAR2, resolved_out OUT BOOLEAN)
   IS
   BEGIN
      DBMS_UTILITY.name_resolve (NAME_IN
                                ,objtype_in
                                ,sch
                                ,part1
                                ,part2
                                ,dblink
                                ,part1_type
                                ,object_number
                                );
      resolved_out := TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         resolve_out := FALSE;
   END try_resolve;

   PROCEDURE try_as_synonym
   IS
      sqlc         NUMBER         := SQLCODE;
      whoisowner   VARCHAR2 (100) := '';
      t_owner      VARCHAR2 (100);
      t_name       VARCHAR2 (100);
      r_owner      VARCHAR2 (100);
      r_name       VARCHAR2 (100);
      s_owner      VARCHAR2 (100);

      CURSOR c1
      IS
         SELECT owner
               ,table_owner
               ,table_name
           FROM ALL_SYNONYMS
          WHERE synonym_name = r_name;

      FUNCTION get_owner (NAME IN VARCHAR2)
         RETURN VARCHAR2
      AS
         retval   VARCHAR2 (100) := '';
         pos      INTEGER;
      BEGIN
         pos := INSTR (NAME, '.');

         IF pos > 0
         THEN
            retval := SUBSTR (NAME, 1, pos - 1);
         END IF;

         RETURN UPPER (retval);
      END;

      FUNCTION get_name (NAME IN VARCHAR2)
         RETURN VARCHAR2
      AS
         retval   VARCHAR2 (100) := NAME;
         pos      INTEGER;
      BEGIN
         pos := INSTR (NAME, '.');

         IF pos > 0
         THEN
            retval := SUBSTR (NAME, pos + 1);
         END IF;

         RETURN UPPER (retval);
      END;
   BEGIN
      IF sqlc = -6564
      THEN
         r_name := get_name (NAME_IN);
         r_owner := get_owner (NAME_IN);

         IF r_owner IS NULL
         THEN
            r_owner := USER;
         END IF;

         OPEN c1;

         LOOP
            FETCH c1
             INTO s_owner
                 ,t_owner
                 ,t_name;

            EXIT WHEN c1%NOTFOUND;

            IF s_owner = r_owner
            THEN
               whoisowner := s_owner;
               EXIT;
            ELSIF s_owner = 'PUBLIC'
            THEN
               whoisowner := s_owner;
            END IF;
         END LOOP;

         CLOSE c1;

         IF (t_owner IS NULL) OR (s_owner = 'PUBLIC')
         THEN
            snc (t_name, objtype_in);
         ELSE
            snc (t_owner || '.' || t_name, objtype_in);
         END IF;
      ELSE
         RAISE;
      END IF;
   END try_as_synonym;
BEGIN
   try_resolve (NAME_IN, l_resolved);

   IF NOT l_resolved
   THEN
      try_as_synonym;
   ELSE
      /* If the object number is NULL, name resolution failed. */
      IF object_number IS NULL
      THEN
         DBMS_OUTPUT.put_line (   'Name "'
                               || NAME_IN
                               || '" does not identify a valid object.'
                              );
      ELSE
         /* Display the schema, which is always available. */
         DBMS_OUTPUT.put_line ('Schema: ' || sch);

         /* If there is a first part to name, have a package module */
         IF part1 IS NOT NULL
         THEN
            /* Display the first part of the name */
            DBMS_OUTPUT.put_line (object_type (part1_type) || ': ' || part1);

            /* If there is a second part, display that. */
            IF part2 IS NOT NULL
            THEN
               DBMS_OUTPUT.put_line ('Name: ' || part2);
            END IF;
         ELSE
            /* No first part of name. Just display second part. */
            DBMS_OUTPUT.put_line (object_type (part1_type) || ': ' || part2);
         END IF;

         /* Display the database link if it is present. */
         IF dblink IS NOT NULL
         THEN
            DBMS_OUTPUT.put_line ('Database Link:' || dblink);
         END IF;
      END IF;
   END IF;
END snc;
/