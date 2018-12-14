CREATE OR REPLACE PROCEDURE Snc (NAME_IN IN VARCHAR2, context_in IN PLS_INTEGER)
IS
   /* variables to hold components of the name */
   sch             VARCHAR2 (100);
   part1           VARCHAR2 (100);
   part2           VARCHAR2 (100);
   dblink          VARCHAR2 (100);
   part1_type      NUMBER;
   object_number   NUMBER;

   /*--------------------- Local Module -----------------------*/
   FUNCTION object_type (type_in IN INTEGER)
      RETURN VARCHAR2
   /* Return name for integer type */
   IS
      table_type       CONSTANT INTEGER       := 2;
      synonym_type     CONSTANT INTEGER       := 5;
      procedure_type   CONSTANT INTEGER       := 7;
      function_type    CONSTANT INTEGER       := 8;
      package_type     CONSTANT INTEGER       := 9;
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
      ELSE
         retval := TO_CHAR (type_in);
      END IF;

      RETURN retval;
   END;
BEGIN
   /* Break down the name into its components */
   DBMS_UTILITY.name_resolve (NAME_IN
                             ,context_in
                             ,sch
                             ,part1
                             ,part2
                             ,dblink
                             ,part1_type
                             ,object_number
                             );

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
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (   'Error resolving "'
                            || NAME_IN
                            || '" with context '
                            || context_in
                           );
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END Snc;
/
