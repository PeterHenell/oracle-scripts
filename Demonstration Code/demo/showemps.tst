@showemps.sp
@showemps2.sp
@showemps3.sp
CREATE OR REPLACE PROCEDURE compare_showemps (counter IN INTEGER)
IS   
   time1 VARCHAR2(200);
   time2 VARCHAR2(200);
BEGIN
   plvtmr.set_factor (counter);

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      showemps2;
   END LOOP;                              
   time1 := PLVtmr.elapsed_message ('static');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      showemps3;
   END LOOP;
   time2 := PLVtmr.elapsed_message ('NDS');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      showemps;
   END LOOP;
   sf_timer.show_elapsed_time ('DBMS_SQL');
   p.l (time1);
   p.l (time2);
END;
/
exec compare_showemps (100);
