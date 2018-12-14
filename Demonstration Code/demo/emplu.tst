CREATE OR REPLACE PROCEDURE test_emplu (
   counter          IN   PLS_INTEGER
 , employee_id_in   IN   employees.employee_id%TYPE := 138
 , run_query_in     IN   BOOLEAN DEFAULT TRUE
)
IS
   emprec   employees%ROWTYPE;
BEGIN
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      emprec := emplu2.onerow_incremental (employee_id_in);
   END LOOP;

   sf_timer.show_elapsed_time ('JIT index-by table');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      emprec := emplu2.onerow (employee_id_in);
   END LOOP;

   sf_timer.show_elapsed_time ('associative array caching');

   --
   IF run_query_in
   THEN
      sf_timer.start_timer;

      FOR i IN 1 .. counter
      LOOP
         emprec := emplu1.onerow (employee_id_in);
      END LOOP;

      sf_timer.show_elapsed_time ('database table lookup');
   END IF;

   --
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      emprec := emplu3.onerow (employee_id_in);
   END LOOP;

   sf_timer.show_elapsed_time ('associative array with bulk collect');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      emprec := emplu3.onerow ('Vargas');
   END LOOP;

   sf_timer.show_elapsed_time
                         ('string-indexed associative array with bulk collect');
/*
database table Elapsed: 5.07 seconds. Factored: .00005 seconds.
associative array Elapsed: .22 seconds. Factored: 0 seconds.
JIT index-by table Elapsed: .34 seconds. Factored: 0 seconds.
Loaded into temporary cache = 11449
associative array with bulk collect Elapsed: .24 seconds. Factored: 0 seconds.
string-indexed associative array with bulk collect Elapsed: .15 seconds. Factored: 0 seconds.
*/
END;
/