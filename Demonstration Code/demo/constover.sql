/*
   Test overhead of packaged constant vs. local variable.
*/
CREATE OR REPLACE PACKAGE val
IS
   val VARCHAR2(100) := RPAD ('abc', 100, 'd');
END;
/
CREATE OR REPLACE PROCEDURE test_val (counter IN INTEGER)
IS
   mval VARCHAR2(100);
   lval VARCHAR2(100) := RPAD ('abc', 100, 'd');
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR rep IN 1 .. counter
   LOOP
      mval := lval;
   END LOOP;
   sf_timer.show_elapsed_time ('Local');

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR rep IN 1 .. counter
   LOOP
      mval := val.val;
   END LOOP;
   sf_timer.show_elapsed_time ('Pkg');
END;
/
