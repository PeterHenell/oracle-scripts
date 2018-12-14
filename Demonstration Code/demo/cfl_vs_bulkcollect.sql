/*
Need employees table. Can install from:

hr_schema_install.sql
*/

DROP TABLE employees_big
/
CREATE TABLE employees_big
AS SELECT e1.* FROM employees e1, employees e2, employees e3
/

CREATE OR REPLACE PROCEDURE cfl_vs_bulkcollect (
   iterations_in   IN   PLS_INTEGER := 1
)
IS
   TYPE employee_tt IS TABLE OF employees_big%ROWTYPE
      INDEX BY BINARY_INTEGER;

   CURSOR big_cur
   IS
      SELECT *
        FROM employees_big;

   l_start_time   PLS_INTEGER;

   PROCEDURE start_timing
   IS
   BEGIN
      DBMS_SESSION.free_unused_user_memory;
      l_start_time := DBMS_UTILITY.get_cpu_time;
   END start_timing;

   PROCEDURE show_elapsed_time (str IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (   '"'
                            || str
                            || '"  Elapsed CPU time: '
                            || TO_CHAR (  DBMS_UTILITY.get_cpu_time
                                        - l_start_time
                                       )
                           );
   END show_elapsed_time;

   PROCEDURE cfl
   IS
      l_employees   employee_tt;
   BEGIN
      start_timing ();

      FOR indx IN 1 .. iterations_in
      LOOP
         FOR rec IN (SELECT *
                       FROM employees_big)
         LOOP
            l_employees (NVL (l_employees.LAST, 0) + 1) := rec;
         END LOOP;
      END LOOP;

      show_elapsed_time ('Cursor For Loop');
   END cfl;

   PROCEDURE bulk_collect
   IS
      l_employees   employee_tt;
   BEGIN
      start_timing ();

      FOR indx IN 1 .. iterations_in
      LOOP
         SELECT *
         BULK COLLECT INTO l_employees
           FROM employees_big;
      END LOOP;

      show_elapsed_time ('Bulk Collect');
   END bulk_collect;

   PROCEDURE bulk_with_limit (limit_in IN PLS_INTEGER)
   IS
      l_employees   employee_tt;
   BEGIN
      start_timing ();

      FOR indx IN 1 .. iterations_in
      LOOP
         OPEN big_cur;

         LOOP
            FETCH big_cur
            BULK COLLECT INTO l_employees LIMIT limit_in;

            EXIT WHEN l_employees.COUNT = 0;
         END LOOP;

         CLOSE big_cur;
      END LOOP;

      show_elapsed_time ('Bulk Collect with LIMIT ' || limit_in);
   END bulk_with_limit;

   PROCEDURE run_all (order_in IN VARCHAR2)
   IS
   BEGIN
      CASE order_in
         WHEN 'bulk first'
         THEN
            bulk_with_limit (100);
            bulk_with_limit (500);
            bulk_with_limit (10000);
            cfl ();
            bulk_collect ();
         WHEN 'bulk last'
         THEN
            cfl ();
            bulk_collect ();
            bulk_with_limit (100);
            bulk_with_limit (500);
            bulk_with_limit (10000);
      END CASE;
   END run_all;
BEGIN
   run_all ('bulk first');
   run_all ('bulk last');
END;
/

BEGIN
   cfl_vs_bulkcollect (iterations_in => 1);
/*
Results

"Bulk Collect with LIMIT 100"  Elapsed CPU time: 347
"Bulk Collect with LIMIT 500"  Elapsed CPU time: 335
"Bulk Collect with LIMIT 10000"  Elapsed CPU time: 323
"Cursor For Loop"  Elapsed CPU time: 586
"Bulk Collect"  Elapsed CPU time: 461

"Cursor For Loop"  Elapsed CPU time: 584
"Bulk Collect"  Elapsed CPU time: 461
"Bulk Collect with LIMIT 100"  Elapsed CPU time: 331
"Bulk Collect with LIMIT 500"  Elapsed CPU time: 312
"Bulk Collect with LIMIT 10000"  Elapsed CPU time: 327

*/
END;
/