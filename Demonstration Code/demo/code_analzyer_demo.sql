CREATE OR REPLACE PROCEDURE process_employee (department_id_in IN NUMBER)
IS
   l_id       NUMBER;
   l_salary   NUMBER (9, 2);
   l_name     VARCHAR2 (100);

   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id, salary, last_name || ',' || first_name lname
        FROM employees
       WHERE department_id = department_id_in;
BEGIN
   OPEN emps_in_dept_cur;

   LOOP
      FETCH emps_in_dept_cur
      INTO l_id, l_salary, l_name;

      EXIT WHEN emps_in_dept_cur%NOTFOUND;

      IF l_name NOT LIKE 'Feuer%'
      THEN
         UPDATE employees
            SET salary = l_salary * 10
          WHERE employee_id = l_id;
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20011
       ,     'Error updating employee '
          || l_employee_id
          || CHR (10)
          || sys.DBMS_UTILITY.format_error_stack ()
          || CHR (10)
          || sys.DBMS_UTILITY.format_error_backtrace ());
END;
/