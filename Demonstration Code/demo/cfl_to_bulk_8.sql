/*
This version uses LIMIT with BULK COLLECT 
to avoid problems with massive tables.

Also shows that in 11g, we can reference fields
or records.
*/

CREATE OR REPLACE PROCEDURE log_error (
   msg_in    IN   VARCHAR2 DEFAULT NULL
 , code_in   IN   PLS_INTEGER DEFAULT NULL
)
IS
BEGIN
   -- A "stub" program that simply displays the error information.
   DBMS_OUTPUT.put_line (   'Error message: '
                         || NVL (msg_in, DBMS_UTILITY.format_error_stack)
                        );
   DBMS_OUTPUT.put_line ('Error code: ' || NVL (code_in, SQLCODE));
END log_error;
/

CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in     IN   employees.department_id%TYPE
 , newsal_in   IN   employees.salary%TYPE
)
IS
   bulk_errors   EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   CURSOR employees_cur
   IS
      SELECT     *
            FROM employees
           WHERE department_id = dept_in
      FOR UPDATE;

   TYPE employees_tt IS TABLE OF employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_employees   employees_tt;

   PROCEDURE insert_history
   IS
   BEGIN
      FORALL indx IN l_employees.FIRST .. l_employees.LAST SAVE EXCEPTIONS
         INSERT INTO employee_history
                     (employee_id
                    , salary, hire_date
                     )
              VALUES (l_employees (indx).employee_id
                    , l_employees (indx).salary, l_employees (indx).hire_date
                     );
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
         LOOP
            -- Log the error
            log_error
               (   'Unable to insert history row for employee '
                || l_employees (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX).employee_id
              , SQL%BULK_EXCEPTIONS (indx).ERROR_CODE
               );
            -- Delete this row so that the update will not take place.
            l_employees.DELETE (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX);
         END LOOP;
   END insert_history;

   PROCEDURE update_employee
   IS
   BEGIN
      -- Use Oracle10g INDICES OF to use what may now be
      -- a sparsely-populated employee_ids collection.
      FORALL indx IN INDICES OF l_employees SAVE EXCEPTIONS
         UPDATE employees
            SET salary = newsal_in
              , hire_date = l_employees (indx).hire_date
          WHERE employee_id = l_employees (indx).employee_id;
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
         LOOP
            -- Now I simply log the error...
            log_error
               (   'Unable to update salary for employee '
                || l_employees (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX).employee_id
              , SQL%BULK_EXCEPTIONS (indx).ERROR_CODE
               );
         END LOOP;
   END update_employee;
BEGIN
   OPEN employees_cur;

   LOOP
      FETCH employees_cur
      BULK COLLECT INTO l_employees LIMIT 100;

      EXIT WHEN l_employees.COUNT = 0;
      insert_history;
      update_employee;
   END LOOP;
END upd_for_dept;
/