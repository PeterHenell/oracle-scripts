DECLARE
   n NUMBER;
BEGIN
   sf_timer.start_timer;
   FOR repind IN 1 .. 10000
   LOOP
      BEGIN
         n := TO_NUMBER ('123&&firstparm');
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;
   END LOOP;
   sf_timer.show_elapsed_time ('TO_NUMBER');
END;
/
In Oracle8.1.5:

SQL> @temp 4
old   8:          n := TO_NUMBER ('123&&firstparm');
new   8:          n := TO_NUMBER ('1234');
TO_NUMBER Elapsed: .03 seconds. Factored: .00006 seconds.

PL/SQL procedure successfully completed.

SQL> @temp a
old   8:          n := TO_NUMBER ('123&&firstparm');
new   8:          n := TO_NUMBER ('123a');
TO_NUMBER Elapsed: 10.97 seconds. Factored: .02194 seconds.

In Oracle8.0.5:

SQL> @temp 4
old   8:          n := TO_NUMBER ('123&&firstparm');
new   8:          n := TO_NUMBER ('1234');
TO_NUMBER Elapsed: .03 seconds.

PL/SQL procedure successfully completed.

SQL> @temp a
old   8:          n := TO_NUMBER ('123&&firstparm');
new   8:          n := TO_NUMBER ('123a');
TO_NUMBER Elapsed: .04 seconds.
