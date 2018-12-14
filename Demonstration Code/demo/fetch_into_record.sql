/* Package with cursor */

CREATE OR REPLACE PACKAGE with_cursors
IS
   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id,
             salary,
             last_name || ',' || first_name lname
        FROM employees
       WHERE department_id = department_id;
END;
/

/* Hard-coded list of variables */

PROCEDURE process_employee (department_id IN NUMBER)
IS
   l_id       NUMBER;
   l_salary   NUMBER (9, 2);
   l_name     VARCHAR2 (100);
BEGIN
   OPEN with_cursors.emps_in_dept_cur;

   LOOP
      FETCH with_cursors.emps_in_dept_cur
      INTO l_id, l_salary, l_name;

      EXIT WHEN with_cursors.emps_in_dept_cur%NOTFOUND;
   END LOOP;

   CLOSE with_cursors.emps_in_dept_cur;
END;
/

/* Fetch into record */

PROCEDURE process_employee (department_id IN NUMBER)
IS
   l_emp_info   with_cursors.emps_in_dept_cur%ROWTYPE;
BEGIN
   OPEN with_cursors.emps_in_dept_cur;

   LOOP
      FETCH with_cursors.emps_in_dept_cur INTO l_emp_info;

      EXIT WHEN with_cursors.emps_in_dept_cur%NOTFOUND;
   END LOOP;

   CLOSE with_cursors.emps_in_dept_cur;
END;
/

/* Can you find the "disconnect" or assumption made here? */

PROCEDURE process_employee (department_id IN NUMBER)
IS
   CURSOR emps_cur
   IS
      SELECT *
        FROM employees
       WHERE department_id = process_employee.department_id;

   l_emp_info   employees%ROWTYPE;
BEGIN
   FOR rec IN emps_cur
   LOOP
      NULL;
   END LOOP;
END;
/