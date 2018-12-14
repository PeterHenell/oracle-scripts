CREATE OR REPLACE PROCEDURE upd_for_dept2 (
   dept_in   IN   employee.department_id%TYPE
 , newsal    IN   employee.salary%TYPE
)
-- Three steps with BULK COLLECT and FORALL
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   employees    employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;

   salaries     salary_tt;

   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;

   hire_dates   hire_date_tt;
BEGIN