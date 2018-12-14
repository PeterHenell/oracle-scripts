/*
This version replaces the use of SAVE EXCEPTION with LOG ERRORS
to continue past errors.

Idea from Marie at Twin Cities training Sept 25-26, 2007.
*/

DROP TABLE employee_history
/

CREATE TABLE employee_history (
   employee_id NUMBER,
   salary NUMBER (5),
   hire_date DATE not null
)
/

DECLARE
   l_spec   q$error_manager.maxvarchar2_t;
   l_body   q$error_manager.maxvarchar2_t;

   PROCEDURE do_setup (table_in IN VARCHAR2)
   IS
   BEGIN
      q$error_manager.setup_error_log (table_in
                                     , err_log_package_spec      => l_spec
                                     , err_log_package_body      => l_body
                                      );

      EXECUTE IMMEDIATE l_spec;

      EXECUTE IMMEDIATE l_body;
   END do_setup;
BEGIN
   do_setup ('EMPLOYEES');
   do_setup ('EMPLOYEE_HISTORY');
END;
/

CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in IN employees.department_id%TYPE
 , newsal_in IN employees.salary%TYPE
)
IS
   TYPE error_log_t IS TABLE OF err$_employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   g_error_log    error_log_t;

   TYPE employee_tt IS TABLE OF employees.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   employee_ids   employee_tt;

   TYPE salary_tt IS TABLE OF employees.salary%TYPE
      INDEX BY BINARY_INTEGER;

   salaries       salary_tt;

   TYPE hire_date_tt IS TABLE OF employees.hire_date%TYPE
      INDEX BY BINARY_INTEGER;

   hire_dates     hire_date_tt;

   PROCEDURE get_employee_data
   IS
   BEGIN
      SELECT     employee_id, salary, hire_date
      BULK COLLECT INTO employee_ids, salaries, hire_dates
            FROM employees
           WHERE department_id = dept_in
      FOR UPDATE;
   END get_employee_data;

   PROCEDURE insert_history
   IS
   BEGIN
      /* Set some hire dates to NULL to force errors. 
      FOR indx IN 1 .. hire_dates.COUNT 
      LOOP
         IF MOD (indx, 2) = 0 THEN
            hire_dates(indx) := NULL;
         END IF;
      END LOOP;
      */
      
      FORALL indx IN employee_ids.FIRST .. employee_ids.LAST
         INSERT INTO employee_history
                     (employee_id, salary, hire_date
                     )
              VALUES (employee_ids (indx), salaries (indx), hire_dates (indx) 
                     )
         LOG ERRORS REJECT LIMIT UNLIMITED;
   END insert_history;

   PROCEDURE update_employee
   IS
      /*
      Get errors from error log and use that to avoid updates.
      */
      l_history_errlog   elp$_employee_history.error_log_tc
                               := elp$_employee_history.error_log_contents
                                                                          ();

      PROCEDURE remove_employee_id (id_in IN employees.employee_id%TYPE)
      IS
      BEGIN
         FOR indx IN 1 .. employee_ids.COUNT
         LOOP
            IF employee_ids (indx) = id_in
            THEN
               employee_ids.DELETE (indx);
            END IF;
         END LOOP;
      END remove_employee_id;
   BEGIN
      /*
      Remove from the employee_ids list any IDs that are
      in the history error log.
      */
      FOR indx IN 1 .. l_history_errlog.COUNT
      LOOP
         remove_employee_id (l_history_errlog (indx).employee_id);
      END LOOP;

      /* Increase size of salary to force errors. */
      
      FORALL indx IN INDICES OF employee_ids 
         UPDATE employees
            SET salary = newsal_in * 100000
              , hire_date = hire_dates (indx)
          WHERE employee_id = employee_ids (indx)
          LOG ERRORS REJECT LIMIT UNLIMITED;
   END update_employee;
BEGIN
   get_employee_data;
   insert_history;
   update_employee;
END upd_for_dept;
/

BEGIN
   upd_for_dept (90, 10000);
END;
/

SELECT eh.ORA_ERR_OPTYP$, eh.ORA_ERR_MESG$, eh.employee_id
  FROM err$_employee_history eh
/

SELECT ee.ORA_ERR_OPTYP$, ee.ORA_ERR_MESG$, ee.LAST_NAME
  FROM err$_employees ee
/

