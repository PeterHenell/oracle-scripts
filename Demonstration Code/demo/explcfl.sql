SET VERIFY OFF
@ssoo
DECLARE
   CURSOR empcur
   IS
      SELECT *
        FROM employee;
   rec empcur%ROWTYPE;
BEGIN
   plvtmr.set_factor (&&firstparm);
   sf_timer.start_timer;
   FOR i IN 1 .. &&firstparm
   LOOP
      FOR rec IN empcur
      LOOP
         NULL;
      END LOOP;
   END LOOP;
   sf_timer.show_elapsed_time ('CFL');

   sf_timer.start_timer;
   FOR i IN 1 .. &&firstparm
   LOOP
      OPEN empcur;
      LOOP
         FETCH empcur INTO rec;
         EXIT WHEN empcur%NOTFOUND;
      END LOOP;
      CLOSE empcur;
   END LOOP;
   sf_timer.show_elapsed_time ('Explicit');

END;
/
