CREATE OR REPLACE PROCEDURE prepare_raise_value (
   raise_in       IN       employee.salary%TYPE
 , employee_in    IN       employee.employee_id%TYPE
 , salary_inout   IN OUT   employee.salary%TYPE
)
IS
BEGIN
   -- Placeholder for program with VERY complicated
   -- logic, justifying the running of this SQL
   -- statement inside a PL/SQL loop.
   NULL;
END;
/

REM The kind of code that is likely to cause
REM Snapshot too old and Rollback segment too small errors

CREATE OR REPLACE PROCEDURE raise_across_dept1 (
   dept_in    IN   employee.department_id%TYPE
 , raise_in   IN   employee.salary%TYPE
)
-- One step with cursor FOR loop
IS
   CURSOR emp_cur
   IS
      SELECT employee_id, salary
        FROM employee
       WHERE department_id = dept_in;
BEGIN
   FOR rec IN emp_cur
   LOOP
      prepare_raise_value (raise_in, rec.employee_id, rec.salary);

      UPDATE employee
         SET salary = rec.salary
       WHERE employee_id = rec.employee_id;
   END LOOP;
END raise_across_dept1;
/

REM Traditional incremental commit logic.
REM This will not help with Snapshot too old at all

CREATE OR REPLACE PROCEDURE raise_across_dept2 (
   dept_in           IN   employee.department_id%TYPE
 , raise_in          IN   employee.salary%TYPE
 , commit_after_in   IN   PLS_INTEGER
)
IS
   l_counter   PLS_INTEGER;

   CURSOR emp_cur
   IS
      SELECT employee_id, salary
        FROM employee
       WHERE department_id = dept_in;
BEGIN
   l_counter := 1;

   FOR rec IN emp_cur
   LOOP
      prepare_raise_value (raise_in, rec.employee_id, rec.salary);

      UPDATE employee
         SET salary = rec.salary
       WHERE employee_id = rec.employee_id;

      IF l_counter >= commit_after_in
      THEN
         COMMIT;
         l_counter := 1;
      ELSE
         l_counter := l_counter + 1;
      END IF;
   END LOOP;

   COMMIT;
END raise_across_dept2;
/

REM Use of BULK COLLECT could bypass Snapshot too old problem
REM Use of FORALL could hit the Rollback segment too small problem FASTER

CREATE OR REPLACE PROCEDURE raise_across_dept3 (
   dept_in           IN   employee.department_id%TYPE
 , raise_in          IN   employee.salary%TYPE
 , commit_after_in   IN   PLS_INTEGER
)
IS
   l_counter      PLS_INTEGER;

   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   employee_ids   employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;

   salaries       salary_tt;
BEGIN
   SELECT employee_id, salary
   BULK COLLECT INTO employee_ids, salaries
     FROM employee
    WHERE department_id = dept_in;

   FOR indx IN employee_ids.FIRST .. employee_ids.LAST
   LOOP
      prepare_raise_value (raise_in, employee_ids (indx), salaries (indx));
   END LOOP;

   FORALL indx IN employee_ids.FIRST .. employee_ids.LAST
      UPDATE employee
         SET salary = salaries (indx)
       WHERE employee_id = employee_ids (indx);
   COMMIT;
END raise_across_dept3;
/

REM Incremental commit processing with FORALL

CREATE OR REPLACE PROCEDURE raise_across_dept4 (
   dept_in           IN   employee.department_id%TYPE
 , raise_in          IN   employee.salary%TYPE
 , limit_bulk_in     IN   PLS_INTEGER DEFAULT 10000
 , commit_after_in   IN   PLS_INTEGER DEFAULT 1000
)
IS
   l_last         PLS_INTEGER;
   l_start        PLS_INTEGER;
   l_end          PLS_INTEGER;

   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;

   employee_ids   employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;

   salaries       salary_tt;

   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id, salary
        FROM employee
       WHERE department_id = dept_in;
BEGIN
   OPEN emps_in_dept_cur;

   LOOP
      FETCH emps_in_dept_cur
      BULK COLLECT INTO employee_ids, salaries LIMIT limit_bulk_in;

      EXIT WHEN employee_ids.COUNT = 0;
      l_last := employee_ids.COUNT;
      l_start := 1;

      FOR indx IN l_start .. l_last
      LOOP
         prepare_raise_value (raise_in, employee_ids (indx), salaries (indx));
      END LOOP;

      /* WARNING: I have never actually run this code! */
      LOOP
         EXIT WHEN l_start > l_last;
         l_end := LEAST (l_start + commit_after_in, l_last);

         -- SIG/Philly Jan 2007: use save exceptions here too!
         BEGIN
            FORALL indx IN l_start .. l_end SAVE EXCEPTIONS
               UPDATE employee
                  SET salary = salaries (indx)
                WHERE employee_id = employee_ids (indx);
         EXCEPTION
            WHEN errpkg.bulk_errors
            THEN
               -- Log or recover any errors.
               NULL;
         END;

         --
         COMMIT;
         l_start := l_end + 1;
      END LOOP;

      COMMIT;
   END LOOP;
END raise_across_dept4;
/

REM Move DML logic inside BULK COLLECT LIMIT loop:
REM This is your best chance at avoiding both errors.