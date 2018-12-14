/* Analyzes overhead of auton transactions. */

CREATE OR REPLACE PROCEDURE test_auton_overhead (
   counter IN INTEGER)
IS
   b   BOOLEAN;
BEGIN
   ROLLBACK;

   --sf_timer.set_factor (counter);
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      logpkg.putline (
         repind
       ,  'Wow! ' || repind || ' just happened.');
   END LOOP;

   --COMMIT;
   sf_timer.show_elapsed_time ('No commit');

   ROLLBACK; -- TVP 5/2001: clean up between tests! Rik Gurney

   --sf_timer.set_factor (counter);
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      logpkg.putline (
         repind
       ,  'Wow! ' || repind || ' just happened.');
   END LOOP;

   COMMIT;
   sf_timer.show_elapsed_time ('One transaction');

   ROLLBACK;

   --sf_timer.set_factor (counter);
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      logpkg.putline (
         repind
       ,  'Wow! ' || repind || ' just happened.');
      COMMIT;
   END LOOP;

   sf_timer.show_elapsed_time ('Explicit commits'); -- Utrecht 4/2002

   ROLLBACK;

   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      logpkg.saveline (
         repind
       ,  'Wow! ' || repind || ' just happened.');
   END LOOP;

   sf_timer.show_elapsed_time ('Auton TRANSACTION');

   ROLLBACK;
END;
/

BEGIN
   test_auton_overhead (100000);
END;
/