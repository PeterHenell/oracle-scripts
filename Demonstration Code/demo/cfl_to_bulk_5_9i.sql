CREATE OR REPLACE PROCEDURE upd_for_dept2 (
   dept_in   IN   employee.department_id%TYPE
 , newsal    IN   employee.salary%TYPE
)
IS
   bulk_errors   EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   employees     employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;

   salaries      salary_tt;

   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;

   hire_dates    hire_date_tt;

   PROCEDURE insert_history
   IS
      PROCEDURE densify_employees (
         collection_inout   IN OUT NOCOPY   employee_tt
       , same_start_in      IN              BOOLEAN DEFAULT TRUE
       , start_at_in        IN              PLS_INTEGER DEFAULT 1
      )
      IS
         l_start        PLS_INTEGER;
         l_collection   employee_tt;
         l_row          PLS_INTEGER;
      BEGIN
         -- Determine starting row for compressed collection.
         IF same_start_in
         THEN
            l_start := collection_inout.FIRST;
         ELSE
            l_start := NVL (start_at_in, 1);
         END IF;

         l_row := collection_inout.FIRST;

         -- For each element in the original collection, copy it to the
         -- sequentially allocated position in the local version.
         WHILE (l_row IS NOT NULL)
         LOOP
            -- Go to last defined row and add the start position to it.
            l_collection (l_start + l_collection.COUNT) :=
                    collection_inout (l_row);
            l_row := collection_inout.NEXT (l_row);
         END LOOP;

         -- Now copy the local, dense collection back to the IN OUT argument.
         collection_inout := l_collection;
      END densify_employees;

      PROCEDURE densify_salaries (
         collection_inout   IN OUT   salary_tt
       , same_start_in      IN       BOOLEAN DEFAULT TRUE
       , start_at_in        IN       PLS_INTEGER DEFAULT 1
      )
      IS
         l_start        PLS_INTEGER;
         l_collection   salary_tt;
         l_row          PLS_INTEGER;
      BEGIN
         -- Determine starting row for compressed collection.
         IF same_start_in
         THEN
            l_start := collection_inout.FIRST;
         ELSE
            l_start := NVL (start_at_in, 1);
         END IF;

         l_row := collection_inout.FIRST;

         -- For each element in the original collection, copy it to the
         -- sequentially allocated position in the local version.
         WHILE (l_row IS NOT NULL)
         LOOP
            -- Go to last defined row and add the start position to it.
            l_collection (l_start + l_collection.COUNT) :=
                                                     collection_inout (l_row);
            l_row := collection_inout.NEXT (l_row);
         END LOOP;

         -- Now copy the local, dense collection back to the IN OUT argument.
         collection_inout := l_collection;
      END densify_salaries;
   BEGIN
      FORALL indx IN employees.FIRST .. employees.LAST SAVE EXCEPTIONS
         INSERT INTO employee_history
                     (employee_id, salary, hire_date
                     )
              VALUES (employees (indx), salaries (indx), hire_dates (indx)
                     );
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
         LOOP
            -- Remove rows in each array
            log_error;
			-- Voxware 11/2005 - why delete? Just change ID...
			-- employees (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX) := NULL;
            employees.DELETE (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX);
            salaries.DELETE (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX);
         END LOOP;

         -- Remove gaps in all the collections.
         -- Then I can use the same old first to last.
         densify_employees (employees);
         densify_salaries (salaries);
   END insert_history;

   PROCEDURE update_employee
   IS
   BEGIN
      IF employees.COUNT > 0
      THEN
         FORALL indx IN employees.FIRST .. employees.LAST SAVE EXCEPTIONS
            UPDATE employee
               SET salary = newsal
             WHERE employee_id = employees (indx);
      END IF;
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
         LOOP
            -- Now I simply log the error...
            log_error ('Unable to update salary for employee '||
			             employee_ids (SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX),
			SQL%BULK_EXCEPTIONS (indx).ERROR_code);
         END LOOP;
   END update_employee;
BEGIN
   SELECT     employee_id, salary, hire_date
   BULK COLLECT INTO employees, salaries, hire_dates
         FROM employee
        WHERE department_id = dept_in
   FOR UPDATE;

   insert_history;
   update_employee;
END upd_for_dept2;
/
