CREATE OR REPLACE PROCEDURE test_emplu (
   counter          IN INTEGER,
   employee_id_in   IN employees.employee_id%TYPE := 138)
/*

Compare performance of repeated querying of data to
caching in the PGA (packaged collection) and the
new Oracle 11g Result Cache.

Author: Steven Feuerstein

*/
IS
   emprec   employees%ROWTYPE;
BEGIN
   sf_timer.set_factor (counter);
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      emprec := emplu11g.onerow (employee_id_in);
   END LOOP;

   sf_timer.show_elapsed_time ('Oracle 11g result cache');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      emprec := emplu2.onerow (employee_id_in);
   END LOOP;

   sf_timer.show_elapsed_time ('Cache table in PGA memory');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. counter
   LOOP
      emprec := emplu1.onerow (employee_id_in);
   END LOOP;

   sf_timer.show_elapsed_time ('Execute query each time');
   --
   sf_timer.start_timer;

   DECLARE
      onerow_rec   employees%ROWTYPE;
   BEGIN
      FOR i IN 1 .. counter
      LOOP
         BEGIN
            SELECT /*+ result_cache */
                  *
              INTO onerow_rec
              FROM employees
             WHERE employee_id = employee_id_in;
         END;
      END LOOP;

      sf_timer.show_elapsed_time ('Execute RC query in block');
   END;
END;
/