/* Test min and max values for limit clause */

DECLARE
   l_limits    DBMS_SQL.number_table;

   TYPE objects_t IS TABLE OF all_objects%ROWTYPE
                        INDEX BY PLS_INTEGER;

   l_objects   objects_t;

   CURSOR objects_cur
   IS
      SELECT * FROM all_objects;
BEGIN
   l_limits (1) := -1;
   l_limits (2) := 0;
   l_limits (3) := 1;
   l_limits (4) := 1000;
   l_limits (5) := 1001;
   l_limits (6) := 2 ** 31;

   OPEN objects_cur;

   FOR indx IN 1 .. l_limits.COUNT
   LOOP
      DBMS_OUTPUT.put_line ('Limit set to ' || l_limits (indx));

      BEGIN
         FETCH objects_cur
         BULK COLLECT INTO l_objects
         LIMIT l_limits (indx);

         DBMS_OUTPUT.put_line ('Collection size=' || l_objects.COUNT);
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (sys.DBMS_UTILITY.format_error_stack);
      END;
   END LOOP;

   CLOSE objects_cur;
END;