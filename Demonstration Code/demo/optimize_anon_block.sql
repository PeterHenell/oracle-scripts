ALTER SESSION SET plsql_optimize_level=2
/

DECLARE
   CURSOR cur
   IS
      SELECT *
        FROM all_source
       WHERE ROWNUM < 100001;

   one_row     cur%ROWTYPE;

   TYPE t IS TABLE OF cur%ROWTYPE
                INDEX BY PLS_INTEGER;

   many_rows   t;
BEGIN
   sf_timer.start_timer;

   FOR j IN cur
   LOOP
      NULL;
   END LOOP;

   sf_timer.show_elapsed_time ('Optimized');
END test_cursor_performance;
/

ALTER SESSION SET plsql_optimize_level=0
/

DECLARE
   CURSOR cur
   IS
      SELECT *
        FROM all_source
       WHERE ROWNUM < 100001;

   one_row     cur%ROWTYPE;

   TYPE t IS TABLE OF cur%ROWTYPE
                INDEX BY PLS_INTEGER;

   many_rows   t;
BEGIN
   sf_timer.start_timer;

   FOR j IN cur
   LOOP
      NULL;
   END LOOP;

   sf_timer.show_elapsed_time ('No optimization');
END test_cursor_performance;
/

