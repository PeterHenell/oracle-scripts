CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in     IN employees.department_id%TYPE,
   newsal_in   IN employees.salary%TYPE)
IS
   CURSOR emp_cur
   IS
      SELECT employee_id, salary, hire_date
        FROM employees
       WHERE department_id = dept_in;
BEGIN
   FOR rec IN emp_cur
   LOOP
      BEGIN
         SAVEPOINT before_insert;

         INSERT
           INTO employee_history (employee_id, salary, hire_date)
         VALUES (rec.employee_id, rec.salary, rec.hire_date);

         rec.salary := newsal_in;

         adjust_compensation (rec.employee_id, rec.salary);

         UPDATE employees
            SET salary = rec.salary
          WHERE employee_id = rec.employee_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            ROLLBACK TO before_insert;
            log_error;
      END;
   END LOOP;
END upd_for_dept;
/