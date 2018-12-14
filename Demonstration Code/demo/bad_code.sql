PROCEDURE process_employee (department_id_in IN NUMBER)
IS
   l_id     NUMBER (9, 2);
   v_name   VARCHAR2 (100);
   salary NUMBER;

   /* Full name: LAST COMMA FIRST (ReqDoc 123.A.47) */
   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id, salary
           , last_name || ',' || first_name lname
        FROM employees
       WHERE department_id = department_id_in;
BEGIN
   OPEN emps_in_dept_cur;
   LOOP
      FETCH emps_in_dept_cur INTO l_id, salary, v_name;
      IF salary > 10000000 THEN must_be_ceo; END IF;
      analyze_compensation (l_id, salary);
      EXIT WHEN emps_in_dept_cur%NOTFOUND;
   END LOOP;
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      INSERT INTO errlog VALUES (SQLCODE, SQLERRM 
        , 'process_employee', SYSDATE, USER );   
END;
