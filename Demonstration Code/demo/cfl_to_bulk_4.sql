CREATE OR REPLACE PROCEDURE upd_for_dept2 (
   dept_in   IN   employee.department_id%TYPE
 , newsal    IN   employee.salary%TYPE
)
IS
   bulk_errors   EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   employees     employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;

   salaries      salary_tt;

   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;

   hire_dates    hire_date_tt;

   PROCEDURE insert_history
   IS
   BEGIN
      FORALL indx IN employees.FIRST .. employees.LAST SAVE EXCEPTIONS
         INSERT INTO employee_history
                     (employee_id, salary, hire_date
                     )
              VALUES (employees (indx), salaries (indx), hire_dates (indx)
                     );
   END insert_history;

   PROCEDURE update_employees
   IS
   BEGIN
      FORALL indx IN employees.FIRST .. employees.LAST SAVE EXCEPTIONS
         UPDATE employee
            SET salary = newsal
          WHERE employee_id = employees (indx);
   END update_employees;
BEGIN
   SELECT     employee_id, salary, hire_date
   BULK COLLECT INTO employees, salaries, hire_dates
         FROM employee
        WHERE department_id = dept_in
   FOR UPDATE;

   insert_history;
   update_employees;
END upd_for_dept2;
/
