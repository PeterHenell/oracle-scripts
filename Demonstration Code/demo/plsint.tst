CREATE OR REPLACE PROCEDURE test_pls_integer (counter IN INTEGER)
IS
   int INTEGER := 1;
   binint BINARY_INTEGER := 1;
   plsint PLS_INTEGER := 1;
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   LOOP
      EXIT WHEN int > counter;
      int := int + 1;
   END LOOP;
   sf_timer.show_elapsed_time ('INTEGER');

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   LOOP
      EXIT WHEN binint > counter;
      binint := binint + 1;
   END LOOP;
   sf_timer.show_elapsed_time ('BINARY');

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   LOOP
      EXIT WHEN plsint > counter;
      plsint := plsint + 1;
   END LOOP;
   sf_timer.show_elapsed_time ('PLS');
   
END;
/

exec test_pls_integer (&&1)

/*
SQL> @plsint.tst 100000
Input truncated to 1 characters
.INTEGER Elapsed: 4.49 seconds. Factored: .00004 seconds.
.BINARY Elapsed: 4.17 seconds. Factored: .00004 seconds.
.PLS Elapsed: 1.18 seconds. Factored: .00001 seconds.

PL/SQL procedure successfully completed.

SQL> @plsint.tst 10000
Input truncated to 1 characters
.INTEGER Elapsed: .47 seconds. Factored: .00005 seconds.
.BINARY Elapsed: .41 seconds. Factored: .00004 seconds.
.PLS Elapsed: .14 seconds. Factored: .00001 seconds.
*/