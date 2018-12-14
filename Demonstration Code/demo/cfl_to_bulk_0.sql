CREATE OR REPLACE PROCEDURE log_error (
   msg_in    IN VARCHAR2 DEFAULT DBMS_UTILITY.format_error_stack
 , code_in   IN PLS_INTEGER DEFAULT SQLCODE)
IS
BEGIN
   -- A "stub" program that simply displays the error information.
   DBMS_OUTPUT.put_line ('Error message: ' || msg_in);
   DBMS_OUTPUT.put_line ('Error code: ' || code_in);
END log_error;
/

CREATE OR REPLACE PROCEDURE adjust_compensation (
   id_in       IN     employees.employee_id%TYPE
 , sal_inout   IN OUT employees.salary%TYPE)
IS
BEGIN
   /* Really complex stuff */
   NULL;
END adjust_compensation;
/

CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in     IN employees.department_id%TYPE
 , newsal_in   IN employees.salary%TYPE)
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
         INSERT INTO employee_history (employee_id, salary, hire_date)
              VALUES (rec.employee_id, rec.salary, rec.hire_date);

         rec.salary := newsal_in;

         adjust_compensation (rec.employee_id, rec.salary);

         UPDATE employees
            SET salary = rec.salary
          WHERE employee_id = rec.employee_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            log_error;
      END;
   END LOOP;
END upd_for_dept;
/