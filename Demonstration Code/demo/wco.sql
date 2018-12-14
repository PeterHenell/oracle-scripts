@@ssoo

DECLARE
/*
Some results:

8.1.7

Primary Key Elapsed: 1.17 seconds.
ROWID Elapsed: 2.21 seconds.
WCO Elapsed: 3.49 seconds.

SQL>  @wco 100
Primary Key Elapsed: 10.46 seconds.
WCO Elapsed: 7.26 seconds.

PL/SQL procedure successfully completed.

SQL>  @wco 100
Primary Key Elapsed: 7.33 seconds.
WCO Elapsed: 7.05 seconds.

PL/SQL procedure successfully completed.

SQL>  @wco 500
Primary Key Elapsed: 43.33 seconds.
WCO Elapsed: 40.24 seconds.

Primary Key Elapsed: 1.38 seconds. Factored: .00001 seconds.
WCO Elapsed: 2.21 seconds. Factored: .00002 seconds.

*/
   CURSOR cur
   IS
      SELECT        ROWID, employee_id, last_name, hire_date
                  , department_id, salary, commission
               FROM employee
      FOR UPDATE OF last_name;

   vlast_name employee.last_name%TYPE;
   vhire_date employee.hire_date%TYPE;
   vdepartment_id employee.department_id%TYPE;
   vsalary employee.salary%TYPE;
   vcommission employee.commission%TYPE;
   rec cur%ROWTYPE;
BEGIN
   sf_timer.start_timer;

   FOR indx IN 1 .. &&1
   LOOP
      OPEN cur;

      LOOP
         FETCH cur
          INTO rec;

         EXIT WHEN cur%NOTFOUND;

         UPDATE employee
            SET last_name = UPPER (last_name)
          WHERE employee_id = rec.employee_id;
      END LOOP;

      CLOSE cur;
   END LOOP;

   sf_timer.show_elapsed_time ('Primary Key');
   ROLLBACK;
   sf_timer.start_timer;

   FOR indx IN 1 .. &&1
   LOOP
      OPEN cur;

      LOOP
         FETCH cur
          INTO rec;

         EXIT WHEN cur%NOTFOUND;

         UPDATE employee
            SET last_name = UPPER (last_name)
          WHERE ROWID = rec.ROWID;
      END LOOP;

      CLOSE cur;
   END LOOP;

   sf_timer.show_elapsed_time ('ROWID');
   ROLLBACK;
   sf_timer.start_timer;

   FOR indx IN 1 .. &&1
   LOOP
      OPEN cur;

      LOOP
         FETCH cur
          INTO rec;

         EXIT WHEN cur%NOTFOUND;

         UPDATE employee
            SET last_name = UPPER (last_name)
          WHERE CURRENT OF cur;
      END LOOP;

      CLOSE cur;
   END LOOP;

   sf_timer.show_elapsed_time ('WCO');
   ROLLBACK;
END;
/