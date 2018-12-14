@@pkgvar.pkg
CREATE OR REPLACE PROCEDURE test_passing_overhead (counter IN INTEGER)
IS
   thistab pkgvar.reward_tt;
BEGIN
   pkgvar.globtab.DELETE;
   
   FOR rowind IN 1 .. counter
   LOOP
      thistab(rowind).comm := rowind;
      thistab(rowind).nm := 'Steven ' || rowind;
      pkgvar.globtab(rowind).comm := rowind;
      pkgvar.globtab(rowind).nm := 'Steven ' || rowind;
   END LOOP;

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   pkgvar.passtab (thistab);
   sf_timer.show_elapsed_time ('PARAMETER');

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   pkgvar.passtab;
   sf_timer.show_elapsed_time ('GLOBAL');
/*
On 8.1.5:
SQL> @pkgvar.tst 50000
PARAMETER Elapsed: 9.75 seconds. Factored: .0002 seconds.
GLOBAL Elapsed: 1.82 seconds. Factored: .00004 seconds.

On 9.2
SQL> @pkgvar.tst 500000
PARAMETER Elapsed: 13.59 seconds. Factored: .00003 seconds.
GLOBAL Elapsed: 3.91 seconds. Factored: .00001 seconds.
*/
END;
/
EXEC test_passing_overhead (&&1)
