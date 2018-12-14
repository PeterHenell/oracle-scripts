CREATE OR REPLACE PROCEDURE explimpl_comparison (
   id_in        IN   employee.employee_id%TYPE,
   counter_in   IN   PLS_INTEGER,
   outcome_in   IN   VARCHAR2
)
IS
-- Need to run fullname.pks/pkb

   fname   employee_rp.fullname_t;
BEGIN
   PLVtmr.set_factor (counter_in);
   /*
   sf_timer.start_timer;
   FOR i IN 1 .. counter_in
   LOOP
      BEGIN
         SELECT employee_id INTO v FROM employee WHERE employee_id = id_in;
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;
      v := v + 1;
   END LOOP;
   sf_timer.show_elapsed_time (outcome_in || ' Implicit');

   sf_timer.start_timer;
   FOR i IN 1 .. counter_in
   LOOP
      OPEN empcur;
      FETCH empcur INTO v;
      v := v + 1;
      CLOSE empcur;
   END LOOP;
   sf_timer.show_elapsed_time (outcome_in || ' Explicit');

   sf_timer.start_timer;
   FOR i IN 1 .. counter_in
   LOOP
      FOR rec IN empcur
      LOOP
         rec.employee_id := rec.employee_id + 1;
      END LOOP;
   END LOOP;
   sf_timer.show_elapsed_time (outcome_in || ' CFL');
   */
   p.l (''
          );
   sf_timer.start_timer;

   FOR i IN 1 .. counter_in
   LOOP
      fname := employee_rp.fullname (id_in);
   END LOOP;

   sf_timer.show_elapsed_time (outcome_in || ' Implicit Function');
   sf_timer.start_timer;

   FOR i IN 1 .. counter_in
   LOOP
      fname := employee_rp.fullname_explicit (id_in);
   END LOOP;

   sf_timer.show_elapsed_time (outcome_in || ' Explicit Function');
END;
/

BEGIN
   explimpl_comparison (7600, 100000, 'Success');
   --explimpl_comparison (-7600, 100000, 'Failure');
/* 
10000 iterations
Success Implicit Function Elapsed: .78 seconds. Factored: .00008 seconds.
Success Explicit Function Elapsed: .91 seconds. Factored: .00009 seconds.
.
Failure Implicit Function Elapsed: 3.3 seconds. Factored: .00033 seconds.
Failure Explicit Function Elapsed: 3.55 seconds. Factored: .00036 seconds.

100000 iterations
Success Implicit Function Elapsed: 7.67 seconds. Factored: .00008 seconds.
Success Explicit Function Elapsed: 9.13 seconds. Factored: .00009 seconds.
*/   
END;
/

