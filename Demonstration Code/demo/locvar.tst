@ssoo
DECLARE
   copy_tmr tmr_t := tmr_t.make ('Copy to local', &&firstparm);
   nocopy_tmr tmr_t := tmr_t.make ('No copy to local', &&firstparm);
BEGIN
   copy_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec IN (SELECT * FROM employee)
      LOOP
         rec.salary := rec.salary * 2;
         rec.hire_date := rec.hire_date + 1;
         UPDATE employee
            SET salary = rec.salary,
                hire_date =  rec.hire_date
          WHERE last_name = rec.last_name; 
      END LOOP;
      ROLLBACK;
   END LOOP;
   copy_tmr.stop;
   
   nocopy_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec IN (SELECT * FROM employee)
      LOOP
         UPDATE employee
            SET salary = salary * 2,
                hire_date =  hire_date + 1
          WHERE last_name = rec.last_name; 
      END LOOP;
      ROLLBACK;
   END LOOP;
   nocopy_tmr.stop;
END;
/

   