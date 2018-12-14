CREATE OR REPLACE PROCEDURE compare_showemps (counter IN INTEGER)
IS   
   time1 VARCHAR2(200);
BEGIN
   plvtmr.set_factor (counter);

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      showemps;
   END LOOP;                              
   time1 := PLVtmr.elapsed_message ('DBMS_SQL');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      showemps81;
   END LOOP;
   sf_timer.show_elapsed_time ('NDS');
   p.l (time1);
END;
/
