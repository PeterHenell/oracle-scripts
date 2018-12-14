DECLARE
   v NUMBER;
   countstartmr tmr_t := tmr_t.make ('COUNT (*)', &&firstparm);
   count1tmr tmr_t := tmr_t.make ('COUNT (1)', &&firstparm);
BEGIN
   countstartmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      SELECT COUNT(*) INTO v FROM employee_big;
   END LOOP;
   countstartmr.stop;

   count1tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      SELECT COUNT(1) INTO v FROM employee_big;
   END LOOP;
   count1tmr.stop;
END;
/

