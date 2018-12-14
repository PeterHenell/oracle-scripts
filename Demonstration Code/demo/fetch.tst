SET VERIFY OFF

CREATE OR REPLACE PROCEDURE test_fetch (counter IN INTEGER)
IS
   /* Code generated using the RevealNet GenX CGML language,
      namely with the following script:
   
         [foreach]col
            v_[colname] [objname].[colname]%TYPE;
         [endforeach]

            CURSOR cur
            IS
               SELECT 
         [foreach]col[between],
                  [colname]             
         [endforeach]
                 FROM [objname];
         BEGIN
               FETCH cur INTO rec;
               
               FETCH cur INTO                 
         [foreach]col[between],
                  v_[colname]             
         [endforeach]
                  ;
                  
      See the PL/Generator trial download for more information...                     
   */
   v_employee_id employee.employee_id%TYPE;
   v_last_name employee.last_name%TYPE;
   v_first_name employee.first_name%TYPE;
   v_middle_initial employee.middle_initial%TYPE;
   v_job_id employee.job_id%TYPE;
   v_manager_id employee.manager_id%TYPE;
   v_hire_date employee.hire_date%TYPE;
   v_salary employee.salary%TYPE;
   v_commission employee.commission%TYPE;
   v_department_id employee.department_id%TYPE;
   v_empno employee.empno%TYPE;
   v_ename employee.ename%TYPE;
   v_created_by employee.created_by%TYPE;
   v_created_on employee.created_on%TYPE;
   v_changed_by employee.changed_by%TYPE;
   v_changed_on employee.changed_on%TYPE;

   CURSOR cur
   IS
      SELECT
         employee_id,
         last_name,
         first_name,
         middle_initial,
         job_id,
         manager_id,
         hire_date,
         salary,
         commission,
         department_id,
         empno,
         ename,
         created_by,
         created_on,
         changed_by,
         changed_on
        FROM employee;
        
   rec cur%ROWTYPE;
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      OPEN cur;
      LOOP
         FETCH cur INTO
            v_employee_id,
            v_last_name,
            v_first_name,
            v_middle_initial,
            v_job_id,
            v_manager_id,
            v_hire_date,
            v_salary,
            v_commission,
            v_department_id,
            v_empno,
            v_ename,
            v_created_by,
            v_created_on,
            v_changed_by,
            v_changed_on
            ;
         EXIT WHEN cur%NOTFOUND;
      END LOOP;
      CLOSE cur;
   END LOOP;
   sf_timer.show_elapsed_time ('Fetch to variables');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      OPEN cur;
      LOOP
         FETCH cur INTO rec;
         EXIT WHEN cur%NOTFOUND;
      END LOOP;
      CLOSE cur;
   END LOOP;
   sf_timer.show_elapsed_time ('Fetch to record');
END;
/
SET SERVEROUTPUT ON
BEGIN
   test_fetch (1000);
   test_fetch (5000);
END;
/   