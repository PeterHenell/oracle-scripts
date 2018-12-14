PROCEDURE process_employee (department_id IN NUMBER)
IS
   l_id       NUMBER;
   l_salary   NUMBER (9, 2);
   l_name     VARCHAR2 (100);

   /* Full name: LAST COMMA FIRST (ReqDoc 123.A.47) */
   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id, salary, last_name || ',' || first_name lname
        FROM employees
       WHERE department_id = department_id;
BEGIN
   OPEN emps_in_dept_cur;

   LOOP
      FETCH emps_in_dept_cur
        INTO l_id, l_salary, l_name;

      IF l_salary > 10000000
      THEN
         must_be_ceo;
      END IF;

      analyze_compensation (l_id, l_salary, 10000000);

      EXIT WHEN emps_in_dept_cur%NOTFOUND;
   END LOOP;
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20918, 'Something went wrong!');
END;
/
