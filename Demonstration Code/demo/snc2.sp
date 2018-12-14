CREATE OR REPLACE PROCEDURE snc (NAME_IN IN VARCHAR2)
IS
   -- Maximum context allowed by NAME_RESOLVE
   c_max_context    CONSTANT PLS_INTEGER    := 8;
   -- Test context value
   l_context                 PLS_INTEGER    := 0;
   --
   l_resolved                BOOLEAN        := FALSE;
   --
   -- Variables to hold components of the name.
   sch                       VARCHAR2 (100);
   part1                     VARCHAR2 (100);
   part2                     VARCHAR2 (100);
   dblink                    VARCHAR2 (100);
   part1_type                NUMBER;
   object_number             NUMBER;

   -- Collection to hold object type names for type numbers
   TYPE names_tt IS TABLE OF all_objects.object_type%TYPE
      INDEX BY BINARY_INTEGER;

   names_t                   names_tt;
   --
   -- The type numbers I now know about
   table_type       CONSTANT PLS_INTEGER    := 2;
   view_type        CONSTANT PLS_INTEGER    := 4;
   synonym_type     CONSTANT PLS_INTEGER    := 5;
   procedure_type   CONSTANT PLS_INTEGER    := 7;
   function_type    CONSTANT PLS_INTEGER    := 8;
   package_type     CONSTANT PLS_INTEGER    := 9;

   PROCEDURE initialize
   IS
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

   /* Break down the name into its components */
   WHILE (NOT l_resolved AND l_context <= c_max_context)
   LOOP
      BEGIN
         DBMS_UTILITY.name_resolve (NAME_IN
                                   ,l_context
                                   ,sch
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

   /* If the object number is NULL, name resolution failed. */
   IF object_number IS NULL
   THEN
      DBMS_OUTPUT.put_line (   'Name "'
                            || NAME_IN
                            || '" does not identify a valid object.'
                           );
   ELSE
      DBMS_OUTPUT.put_line ('Context: ' || l_context);
      DBMS_OUTPUT.put_line ('Schema: ' || sch);

      IF part1 IS NOT NULL
      THEN
         DBMS_OUTPUT.put_line (name_for_type (part1_type) || ': ' || part1);

         IF part2 IS NOT NULL
         THEN
            DBMS_OUTPUT.put_line ('Name: ' || part2);
         END IF;
      ELSE
         DBMS_OUTPUT.put_line (name_for_type (part1_type) || ': ' || part2);
      END IF;

      IF dblink IS NOT NULL
      THEN
         DBMS_OUTPUT.put_line ('Database Link:' || dblink);
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('SNC Error resolving "' || NAME_IN);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END snc;
/