CREATE OR REPLACE PROCEDURE log_error (
   msg_in IN VARCHAR2
  ,code_in IN PLS_INTEGER
)
IS
BEGIN
   -- A "stub" program that simply displays the error information.
   DBMS_OUTPUT.put_line ('Error message: ' || msg_in);
   DBMS_OUTPUT.put_line ('Error code: ' || code_in);
END log_error;
/

CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in IN employee.department_id%TYPE
  ,newsal_in IN employee.salary%TYPE
)
IS
   CURSOR emp_cur
   IS
      SELECT employee_id
            ,salary
            ,hire_date
        FROM employee
       WHERE department_id = dept_in;
BEGIN
   FOR rec IN emp_cur
   LOOP
      BEGIN
         INSERT INTO employee_history
                     (employee_id, salary, hire_date
                     )
              VALUES (rec.employee_id, rec.salary, rec.hiredate
                     );

         UPDATE employee
            SET salary = newsal_in
          WHERE employee_id = rec.employee_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            log_error;
      END;
   END LOOP;
END upd_for_dept;
/
