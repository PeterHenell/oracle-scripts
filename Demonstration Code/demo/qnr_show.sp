CREATE OR REPLACE PROCEDURE qnr_show (NAME_IN IN VARCHAR2)
AUTHID CURRENT_USER
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
   TYPE names_tt IS TABLE OF all_objects.object_type%TYPE
      INDEX BY BINARY_INTEGER;

   names_t         names_tt;

   PROCEDURE initialize
   IS
      -- The type numbers I now know about
      table_type       CONSTANT PLS_INTEGER := 2;
      view_type        CONSTANT PLS_INTEGER := 4;
      synonym_type     CONSTANT PLS_INTEGER := 5;
      procedure_type   CONSTANT PLS_INTEGER := 7;
      function_type    CONSTANT PLS_INTEGER := 8;
      package_type     CONSTANT PLS_INTEGER := 9;
   BEGIN
      names_t (table_type) := 'Table';
      names_t (view_type) := 'View';
      names_t (synonym_type) := 'Synonym';
      names_t (procedure_type) := 'Procedure';
      names_t (function_type) := 'Function';
      names_t (package_type) := 'Package';
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
   qnxo_name_resolve (NAME_IN
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
      l_string := NAME_IN || ' ==> Schema: ' || sch;

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
END qnr_show;
/