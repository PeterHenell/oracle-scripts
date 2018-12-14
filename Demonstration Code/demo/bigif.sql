CREATE OR REPLACE PROCEDURE bigif (whichthree IN INTEGER, counter IN INTEGER)
IS
   value NUMBER;
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR indx IN 1 .. counter
   LOOP
      value := MOD (indx, 3) + whichthree;
      IF value < 1
      THEN
         NULL;
      ELSIF value < 2
      THEN
         NULL;
      ELSIF value < 3
      THEN
         NULL;
      ELSIF value < 4
      THEN
         NULL;
      ELSIF value < 5
      THEN
         NULL;
      ELSIF value < 6
      THEN
         NULL;
      ELSIF value < 7
      THEN
         NULL;
      ELSIF value < 8
      THEN
         NULL;
      ELSIF value < 9
      THEN
         NULL;
      ELSIF value < 10
      THEN
         NULL;
      ELSIF value < 15
      THEN
         NULL;
      ELSIF value < 16
      THEN
         NULL;
      END IF;
   END LOOP;   
   sf_timer.show_elapsed_time ('Three up from ' || whichthree);
END;
/

BEGIN
   bigif (0, 100000);   
   bigif (13, 100000); 

/*
Three up from 0 Elapsed: 1.68 seconds. Factored: .00002 seconds.
Three up from 13 Elapsed: 2.87 seconds. Factored: .00003 seconds.
*/
END;     
/

exec drop_whatever ('bigif');