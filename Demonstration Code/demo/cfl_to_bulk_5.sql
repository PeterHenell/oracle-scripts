CREATE OR REPLACE PROCEDURE upd_for_dept (
   dept_in IN employees.department_id%TYPE
 , newsal_in IN employees.salary%TYPE
 , bulk_limit_in IN PLS_INTEGER DEFAULT 100
)
IS
   bulk_errors exception;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   TYPE employee_tt
   IS
      TABLE OF employees.employee_id%TYPE
         INDEX BY BINARY_INTEGER;

   employee_ids   employee_tt;

   TYPE salary_tt
   IS
      TABLE OF employees.salary%TYPE
         INDEX BY BINARY_INTEGER;

   salaries       salary_tt;

   TYPE hire_date_tt
   IS
      TABLE OF employees.hire_date%TYPE
         INDEX BY BINARY_INTEGER;

   hire_dates     hire_date_tt;

   CURSOR employees_cur
   IS
          SELECT employee_id, salary, hire_date
            FROM employees
           WHERE department_id = dept_in
      FOR UPDATE ;

   /*
   TYPE employees_tt
   IS
      TABLE OF employees_cur%ROWTYPE
         INDEX BY PLS_INTEGER;
   l_employees employees_tt;
   */

   PROCEDURE fetch_next_set_of_rows (limit_in IN PLS_INTEGER
                               , employee_ids_out   OUT employee_tt
                               , salaries_out   OUT salary_tt
                               , hire_dates_out   OUT hire_date_tt
                                )
   IS
   BEGIN
      FETCH employees_cur
         BULK COLLECT INTO employee_ids_out, salaries_out, hire_dates_out
         LIMIT bulk_limit_in;
   END fetch_next_set_of_rows;

   PROCEDURE adj_comp_for_arrays (employee_ids_io IN OUT employee_tt
                                , salaries_io IN OUT salary_tt
                                 )
   IS
      l_index   PLS_INTEGER;
   BEGIN
      /* IFMC Nov 2008 Cannot go 1 to COUNT */
      l_index := employee_ids_io.FIRST;

      WHILE (l_index IS NOT NULL)
      LOOP
         adjust_compensation (employee_ids_io (l_index), salaries_io (l_index));
         l_index := employee_ids_io.NEXT (l_index);
      END LOOP;
   END adj_comp_for_arrays;

   PROCEDURE insert_history
   IS
   BEGIN
      FORALL indx IN 1 .. employee_ids.COUNT
      SAVE EXCEPTIONS
         INSERT INTO employee_history (employee_id, salary, hire_date
                                      )
             VALUES (employee_ids (indx), salaries (indx), hire_dates (indx)
                    );
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. sql%BULK_EXCEPTIONS.COUNT
         LOOP
            -- Log the error
            log_error (
               'Unable to insert history row for employee '
               || employee_ids (sql%BULK_EXCEPTIONS (indx).ERROR_INDEX)
             , sql%BULK_EXCEPTIONS (indx).ERROR_CODE
            );
            /*
            Communicate this failure to the update phase:
            Delete this row so that the update will not take place.
            */
            employee_ids.delete (sql%BULK_EXCEPTIONS (indx).ERROR_INDEX);
         END LOOP;
   END insert_history;

   PROCEDURE update_employees
   IS
   BEGIN
      /*
        Use Oracle10g INDICES OF to avoid errors
        from a sparsely-populated employee_ids collection.
      */
      FORALL indx IN INDICES OF employee_ids
      SAVE EXCEPTIONS
         UPDATE employees
            SET salary = salaries (indx)
              , hire_date = hire_dates (indx)
          WHERE employee_id = employee_ids (indx);
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. sql%BULK_EXCEPTIONS.COUNT
         LOOP
            log_error (
               'Unable to update salary for employee '
               || employee_ids (sql%BULK_EXCEPTIONS (indx).ERROR_INDEX)
             , sql%BULK_EXCEPTIONS (indx).ERROR_CODE
            );
         END LOOP;
   END update_employees;
BEGIN
   OPEN employees_cur;

   LOOP
      fetch_next_set_of_rows (
         bulk_limit_in, employee_ids, salaries, hire_dates);
      EXIT WHEN employee_ids.COUNT = 0;
      insert_history;
      adj_comp_for_arrays (employee_ids, salaries);
      update_employees;
   END LOOP;
END upd_for_dept;