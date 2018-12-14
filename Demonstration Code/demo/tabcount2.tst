@@tmr81.ot
@@tabcount81.sf
DECLARE
   v INTEGER;
   static_tmr tmr_t := tmr_t.make ('Static', &&1);
   dynamic_tmr tmr_t := tmr_t.make ('Dynamic', &&1);
BEGIN
   static_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      select count(*) into v from employee;
   END LOOP;
   static_tmr.stop;

   dynamic_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      v := tabcount ('employee');
   END LOOP;
   dynamic_tmr.stop;
   
END;
/

