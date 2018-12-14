/* Analyzes overhead of auton transactions. */
CREATE OR REPLACE PROCEDURE Test_Auton (
   counter IN INTEGER)
IS
   b BOOLEAN;
BEGIN
   ROLLBACK;

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      Log81.putline (repind, 'Wow! ' || repind || ' just happened.');
   END LOOP;
   sf_timer.show_elapsed_time ('No commit');
   
   ROLLBACK; -- TVP 5/2001: clean up between tests! Rik Gurney
   
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      Log81.putline (repind, 'Wow! ' || repind || ' just happened.');
   END LOOP;
   COMMIT;
   sf_timer.show_elapsed_time ('One transaction');
   
   ROLLBACK;

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      Log81.putline (repind, 'Wow! ' || repind || ' just happened.');
	  COMMIT;
   END LOOP;
   sf_timer.show_elapsed_time ('Explicit commits'); -- Utrecht 4/2002
      
	  rollback;
	  
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
       Log81.saveline (repind, 
          'Wow! ' || repind || ' just happened.');
   END LOOP;
   sf_timer.show_elapsed_time ('Auton TRANSACTION');

   ROLLBACK;
   
END;
/
