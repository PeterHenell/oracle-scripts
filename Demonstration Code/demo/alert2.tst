declare
   stat INTEGER;
   msg PLV.dbmaxvc2;
BEGIN
   dbms_alert.register ('cant_hire_in_future');

   dbms_alert.waitone (
      'cant_hire_in_future', msg, stat, 10);

   IF stat = 0
   THEN
      p.l (msg);
   else
      p.l ('Time out on wait for alert with error', stat);
   END IF;
END;
/
