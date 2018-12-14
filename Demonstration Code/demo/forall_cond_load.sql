CREATE OR REPLACE PROCEDURE upd_for_dept4 (
   dept_in IN employee.department_id%TYPE
  ,newsal IN employee.salary%TYPE
)
-- Handle conditional logic by partitioning the table.
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;
   employees    employee_tt;
   approved_employees    employee_tt;
   denied_employees    employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;
   salaries     salary_tt;
   approved_salaries     salary_tt;
   denied_salaries     salary_tt;

   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;
   hire_dates   hire_date_tt;
   approved_hire_dates   hire_date_tt;
   denied_hire_dates   hire_date_tt;
   
BEGIN
   SELECT employee_id
         ,salary
         ,hire_date
   BULK COLLECT INTO employees, salaries, hire_dates
     FROM employee
    WHERE department_id = dept_in;

   FOR indx IN employees.FIRST .. employees.LAST
   LOOP
      IF comp_analysis.eligible (employees(indx))
      THEN
         approved_employees (approved_employees.COUNT + 1) := employees (indx);
         approved_salaries (approved_employees.COUNT + 1) := salaries (indx);
         approved_hire_dates (approved_employees.COUNT + 1) := hire_dates (indx);
      ELSE
         denied_employees (denied_employees.COUNT + 1) := employees (indx);
         denied_salaries (denied_employees.COUNT + 1) := salaries (indx);
         denied_hire_dates (denied_employees.COUNT + 1) := hire_dates (indx);
	  END IF;
   END LOOP;

   FORALL indx IN approved_employees.FIRST .. approved_employees.LAST
      SAVE EXCEPTIONS
	  INSERT INTO employee_history
                  (employee_id
                  ,salary
                  ,hire_date, activity
                  )
           VALUES (approved_employees (indx)
                  ,approved_salaries (indx)
                  ,approved_hire_dates (indx), 'RAISE GIVEN'
                  );
				  				  
   FORALL indx IN denied_employees.FIRST .. denied_employees.LAST
      SAVE EXCEPTIONS
      INSERT INTO employee_history
                  (employee_id
                  ,salary
                  ,hire_date, activity
                  )
           VALUES (denied_employees (indx)
                  ,denied_salaries (indx)
                  ,denied_hire_dates (indx), 'RAISE DENIED'
                  );
				  
   FORALL indx IN approved_employees.FIRST .. approved_employees.LAST
      SAVE EXCEPTIONS
      UPDATE employee
         SET salary = newsal
            ,hire_date = approved_hire_dates (indx)
       WHERE employee_id = approved_employees (indx);
END upd_for_dept4;
/
