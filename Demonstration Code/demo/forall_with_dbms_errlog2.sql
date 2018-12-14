ALTER TABLE employees MODIFY salary NUMBER(8,2) NOT NULL
/

CREATE OR REPLACE PROCEDURE adjust_compensation (
   employee_id_in   IN       employees.employee_id%TYPE
 , salary_inout     IN OUT   employees.salary%TYPE
)
IS
BEGIN
   IF salary_inout > 3000
   THEN
      salary_inout := NULL;
      else
      salary_inout := salary_inout / 2;
   END IF;
END adjust_compensation;
/

CREATE OR REPLACE PROCEDURE update_employees (
   department_id_in   IN   employees.department_id%TYPE
)
IS
   CURSOR emp_cur
   IS
      SELECT employee_id, salary
        FROM employees
       WHERE department_id = department_id_in;
BEGIN
   FOR rec IN emp_cur
   LOOP
      adjust_compensation (rec.employee_id, rec.salary);

      UPDATE employees
         SET salary = rec.salary
       WHERE employee_id = rec.employee_id;
   END LOOP;
END update_employees;
/

BEGIN
   update_employees (30);
END;
/

ROLLBACK
/


CREATE OR REPLACE PROCEDURE update_employees_bulk (
   department_id_in   IN   employees.department_id%TYPE
)
IS
   TYPE employee_id_tt IS TABLE OF employees.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   l_employee_ids   employee_id_tt;

   TYPE salary_tt IS TABLE OF employees.salary%TYPE
      INDEX BY BINARY_INTEGER;

   l_salaries       salary_tt;
BEGIN
   SELECT employee_id, salary
   BULK COLLECT INTO l_employee_ids, l_salaries
     FROM employees
    WHERE department_id = department_id_in;

   FOR indx IN 1 .. l_employee_ids.COUNT
   LOOP
      adjust_compensation (l_employee_ids (indx), l_salaries (indx));
   END LOOP;

   FORALL indx IN 1 .. l_employee_ids.COUNT
      UPDATE employees
         SET salary = l_salaries (indx)
       WHERE employee_id = l_employee_ids (indx);
END update_employees_bulk;
/

BEGIN
   update_employees_bulk (30);
END;
/

ROLLBACK
/

CREATE OR REPLACE PROCEDURE update_employees_bulk (
   department_id_in   IN   employees.department_id%TYPE
)
IS
   bulk_errors      EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   TYPE employee_id_tt IS TABLE OF employees.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   l_employee_ids   employee_id_tt;

   TYPE salary_tt IS TABLE OF employees.salary%TYPE
      INDEX BY BINARY_INTEGER;

   l_salaries       salary_tt;
BEGIN
   SELECT employee_id, salary
   BULK COLLECT INTO l_employee_ids, l_salaries
     FROM employees
    WHERE department_id = department_id_in;

   FOR indx IN 1 .. l_employee_ids.COUNT
   LOOP
      adjust_compensation (l_employee_ids (indx), l_salaries (indx));
   END LOOP;

   FORALL indx IN 1 .. l_employee_ids.COUNT SAVE EXCEPTIONS
      UPDATE employees
         SET salary = l_salaries (indx)
       WHERE employee_id = l_employee_ids (indx);
EXCEPTION
   WHEN bulk_errors
   THEN
      FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
      LOOP
         DBMS_OUTPUT.put_line (SQL%BULK_EXCEPTIONS (indx).ERROR_CODE);
         DBMS_OUTPUT.put_line
                            (SQLERRM (  -1
                                      * SQL%BULK_EXCEPTIONS (indx).ERROR_CODE
                                     )
                            );
      END LOOP;
END update_employees_bulk;
/

BEGIN
   update_employees_bulk (30);
END;
/

ROLLBACK
/

BEGIN
   DBMS_ERRLOG.create_error_log (dml_table_name => 'EMPLOYEES');
END;
/

CREATE OR REPLACE PROCEDURE update_employees_bulk (
   department_id_in   IN   employees.department_id%TYPE
)
IS
   TYPE employee_id_tt IS TABLE OF employees.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   l_employee_ids   employee_id_tt;

   TYPE salary_tt IS TABLE OF employees.salary%TYPE
      INDEX BY BINARY_INTEGER;

   l_salaries       salary_tt;

   TYPE error_info_tt IS TABLE OF err$_employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_errors         error_info_tt;
BEGIN   
   DELETE FROM err$_employees;
   
   SELECT employee_id, salary
   BULK COLLECT INTO l_employee_ids, l_salaries
     FROM employees
    WHERE department_id = department_id_in;

   FOR indx IN 1 .. l_employee_ids.COUNT
   LOOP
      adjust_compensation (l_employee_ids (indx), l_salaries (indx));
      END LOOP;

   FORALL indx IN 1 .. l_employee_ids.COUNT
      UPDATE employees
         SET salary = l_salaries (indx)
       WHERE employee_id = l_employee_ids (indx)
       LOG ERRORS REJECT LIMIT UNLIMITED;

   /* Display the error messages. */
   
   SELECT *
   BULK COLLECT INTO l_errors
     FROM err$_employees;

   FOR indx IN 1 .. l_errors.COUNT
   LOOP
     DBMS_OUTPUT.put_line (l_errors (indx).ora_err_mesg$);
   END LOOP;
END update_employees_bulk;
/

BEGIN
   update_employees_bulk (30);
END;
/

ROLLBACK
/
