/*
   Test performance impact of constrained number.
*/
DECLARE
   n NUMBER;
   n10 NUMBER (10);
BEGIN
   PLVtmr.set_factor (1000000);
   sf_timer.start_timer;
   FOR repind IN 1 .. 1000000
   LOOP
      n := 105060;
   END LOOP;
   sf_timer.show_elapsed_time ('NUMBER');

   PLVtmr.set_factor (1000000);
   sf_timer.start_timer;
   FOR repind IN 1 .. 1000000
   LOOP
      n10 := 105060;
   END LOOP;
   sf_timer.show_elapsed_time ('NUMBER(10)');   
END;
/