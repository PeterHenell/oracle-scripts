CREATE OR REPLACE PROCEDURE test_cursor_performance (
   approach   IN   VARCHAR2
)
IS
   t0          INTEGER;
   t1          INTEGER;

   CURSOR cur
   IS
      SELECT *
        FROM all_source
       WHERE ROWNUM < 20001;

   one_row     cur%ROWTYPE;

   TYPE t IS TABLE OF cur%ROWTYPE
      INDEX BY PLS_INTEGER;

   many_rows   t;
BEGIN
   t0 := DBMS_UTILITY.get_cpu_time ();

   CASE approach
      WHEN 'implicit for loop'
      THEN
         FOR j IN cur
         LOOP
            NULL;
         END LOOP;
      WHEN 'bulk fetch 100'
      THEN
         OPEN cur;

         LOOP
            FETCH cur
            BULK COLLECT INTO many_rows LIMIT 100;

            EXIT WHEN many_rows.COUNT () < 1;
         END LOOP;

         CLOSE cur;
      WHEN 'bulk fetch 1000'
      THEN
         OPEN cur;

         LOOP
            FETCH cur
            BULK COLLECT INTO many_rows LIMIT 1000;

            EXIT WHEN many_rows.COUNT () < 1;
         END LOOP;

         CLOSE cur;
   END CASE;

   t1 := DBMS_UTILITY.get_cpu_time ();
   DBMS_OUTPUT.put_line ('Timing for ' || approach || ' = '
                         || TO_CHAR (t1 - t0)
                        );
END test_cursor_performance;
/

BEGIN
   test_cursor_performance ('implicit for loop');
   test_cursor_performance ('bulk fetch 100');
   test_cursor_performance ('bulk fetch 1000');
END;
/