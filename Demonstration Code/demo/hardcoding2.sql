PROCEDURE process_employee (department_id IN NUMBER)
IS
   l_id       NUMBER;
   l_salary   NUMBER (9, 2);
   l_name     VARCHAR2 (100);

   /* Full name: LAST COMMA FIRST (ReqDoc 123.A.47) */
   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id,
             salary,
             last_name || ',' || first_name lname
        FROM employees
       WHERE department_id = department_id;
BEGIN
   OPEN emps_in_dept_cur;

   LOOP
      FETCH emps_in_dept_cur
      INTO l_id, l_salary, l_name;

      IF l_salary > 10000000
      THEN
         DBMS_OUTPUT.put_line (
            'trace - found CE with id ' || l_id);
         must_be_ceo;
      END IF;

      EXIT WHEN emps_in_dept_cur%NOTFOUND;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      INSERT INTO log_table
           VALUES ('process employee',
                   DBMS_UTILITY.format_error_stack,
                   DBMS_UTILITY.format_error_backtrace,
                   DBMS_UTILITY.format_call_stack);
END;
/