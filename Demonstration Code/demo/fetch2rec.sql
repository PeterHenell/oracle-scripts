@@ssoo
DECLARE
   CURSOR cur IS
      SELECT last_name, hire_date, department_id, salary, commission
        FROM employee;
        
   vlast_name employee.last_name%TYPE;
   vhire_date employee.hire_date%TYPE; 
   vdepartment_id employee.department_id%TYPE; 
   vsalary employee.salary%TYPE; 
   vcommission employee.commission%TYPE;
   
   rec cur%ROWTYPE;
BEGIN
   sf_timer.start_timer;
   FOR indx IN 1 .. &&firstparm
   LOOP
      OPEN cur;
      LOOP
         FETCH cur INTO rec;
         EXIT WHEN cur%NOTFOUND;
      END LOOP;
      CLOSE cur;
   END LOOP;
   sf_timer.show_elapsed_time ('Record');
   
   sf_timer.start_timer;
   FOR indx IN 1 .. &&firstparm
   LOOP
      OPEN cur;
      LOOP
         FETCH cur INTO 
            vlast_name, vhire_date, vdepartment_id, vsalary, vcommission;
         EXIT WHEN cur%NOTFOUND;
      END LOOP;
      CLOSE cur;
   END LOOP;
   sf_timer.show_elapsed_time ('Variables');   
END;
/
