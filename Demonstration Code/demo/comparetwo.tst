@ssoo
DECLARE
   num NUMBER;
   str VARCHAR2(4000);

   tmr1 tmr_t := tmr_t.make ('TMR1', &&firstparm);
   tmr2 tmr_t := tmr_t.make ('TMR2', &&firstparm);
BEGIN
   tmr1.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      <>;
   END LOOP;
   tmr1.stop;

   tmr2.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      <>;
   END LOOP;
   tmr2.stop;
END;
/
