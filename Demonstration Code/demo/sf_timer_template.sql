CREATE OR REPLACE PROCEDURE compare_performance (counter IN PLS_INTEGER)
IS
BEGIN
   sf_timer.start_timer;

   FOR indx IN 1 .. counter
   LOOP
      /* Call program here */
      NULL;
   END LOOP;

   sf_timer.show_elapsed_time ('Description');
END;
/