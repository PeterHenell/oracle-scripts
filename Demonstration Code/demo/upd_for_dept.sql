CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in IN employee.department_id%TYPE
  ,newsal IN employee.salary%TYPE
)
-- One step with cursor FOR loop
IS
   CURSOR emp_cur
   IS
      SELECT employee_id, salary, hire_date
        FROM employee
       WHERE department_id = dept_in;
BEGIN
   FOR rec IN emp_cur
   LOOP
      INSERT INTO employee_history
                  (employee_id, salary, hire_date
                  )
           VALUES (rec.employee_id, rec.salary, rec.hire_date
                  );

      UPDATE employee
         SET salary = newsal
       WHERE employee_id = rec.employee_id;
   END LOOP;
END upd_for_dept;
/