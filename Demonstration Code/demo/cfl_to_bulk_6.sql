CREATE TABLE employee_history (
   employee_id NUMBER,
   salary NUMBER,
   hire_date DATE
)
/

CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in IN employees.department_id%TYPE
 , newsal_in IN employees.salary%TYPE
)
IS
   bulk_errors    EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   TYPE employee_tt IS TABLE OF employees.employee_id%TYPE
      INDEX BY PLS_INTEGER;

   employee_ids   employee_tt;

   TYPE salary_tt IS TABLE OF employees.salary%TYPE
      INDEX BY PLS_INTEGER;

   salaries       salary_tt;

   TYPE hire_date_tt IS TABLE OF employees.hire_date%TYPE
      INDEX BY PLS_INTEGER;

   hire_dates     hire_date_tt;
BEGIN
   SELECT employee_id, salary, hire_date
   BULK COLLECT INTO employee_ids, salaries, hire_dates
     FROM employees
    WHERE department_id = dept_in;

   FORALL indx IN employee_ids.FIRST .. employee_ids.LAST SAVE EXCEPTIONS
      EXECUTE IMMEDIATE 'BEGIN
         IF :salary > 2600 THEN
            RAISE PROGRAM_ERROR;
         END IF;
         
         INSERT INTO employee_history
                     (employee_id, salary, hire_date
                     )
              VALUES (:employee_id, :salary, :hire_date
                     );
         UPDATE employees
            SET salary = :new_salary
              , hire_date = hire_date
          WHERE employee_id = :employee_id;                     
       END;'
                  USING salaries (indx)
                      , employee_ids (indx)
                      , hire_dates (indx)
                      , newsal_in;
EXCEPTION
   WHEN bulk_errors
   THEN
      -- Verify the changes....
      SELECT salary
      BULK COLLECT INTO salaries
        FROM employees
       WHERE department_id = dept_in;

      FOR indx IN 1 .. salaries.COUNT
      LOOP
         DBMS_OUTPUT.put_line (salaries (indx));
      END LOOP;

      SELECT employee_id
      BULK COLLECT INTO salaries
        FROM employee_history;

      FOR indx IN 1 .. salaries.COUNT
      LOOP
         DBMS_OUTPUT.put_line (employee_ids (indx));
      END LOOP;

      -- Get rid of the changes....
      ROLLBACK;

      FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
      LOOP
         DBMS_OUTPUT.put_line (   'Error encountered on index '
                               || SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX
                              );
         DBMS_OUTPUT.put_line (   'Error: '
                               || SQL%BULK_EXCEPTIONS (indx).ERROR_CODE
                              );
      END LOOP;
END upd_for_dept;
/