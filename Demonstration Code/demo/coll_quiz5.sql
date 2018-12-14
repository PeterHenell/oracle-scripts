CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in IN employee.department_id%TYPE
  ,newsal_in IN employee.salary%TYPE
)
IS
   TYPE employee_tt IS TABLE OF employee%ROWTYPE
      INDEX BY BINARY_INTEGER;

   employees   employee_tt;
BEGIN
   SELECT *
   BULK COLLECT INTO employees
     FROM employee;

   FOR l_row IN employees.FIRST .. employees.LAST
   LOOP
      DBMS_OUTPUT.put_line (employees (l_row).last_name);
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      log_error;
END upd_for_dept;
/
