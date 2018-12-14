/*
PBA 20050531:
Create a dummy package comp_analysis
*/

CREATE OR REPLACE PACKAGE comp_analysis
IS
   FUNCTION eligible (
      employee_id_in IN employee.employee_id%TYPE)
      RETURN BOOLEAN;
END comp_analysis;
/

CREATE OR REPLACE PACKAGE BODY comp_analysis
IS
   FUNCTION eligible (
      employee_id_in IN employee.employee_id%TYPE)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN ( (employee_id_in MOD 2) = 0);
   END eligible;
END comp_analysis;
/

/*
This script follows the transformation of a program that 
relies on a cursor for loop to do an INSERT and UPDATE 
into a program that relies on BULK COLLECT and FORALL
to get the job done. It also demonstrates how incremental
commits can be done with FORALL.
*/

CREATE OR REPLACE PROCEDURE upd_for_dept1 (
   dept_in   IN employee.department_id%TYPE
 ,  newsal    IN employee.salary%TYPE)
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
      INSERT
        INTO employee_history (employee_id
                             ,  salary
                             ,  hire_date)
      VALUES (rec.employee_id, rec.salary, rec.hire_date);

      UPDATE employee
         SET salary = newsal
       WHERE employee_id = rec.employee_id;
   END LOOP;
END upd_for_dept1;
/

SHOW ERR

CREATE OR REPLACE PROCEDURE upd_for_dept2 (
   dept_in   IN employee.department_id%TYPE
 ,  newsal    IN employee.salary%TYPE)
-- Three steps with BULK COLLECT and FORALL
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
                          INDEX BY BINARY_INTEGER;

   employees    employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
                        INDEX BY BINARY_INTEGER;

   salaries     salary_tt;

   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
                           INDEX BY BINARY_INTEGER;

   hire_dates   hire_date_tt;
BEGIN
   SELECT employee_id, salary, hire_date
     BULK COLLECT INTO employees, salaries, hire_dates
     FROM employee
    WHERE department_id = dept_in
   FOR UPDATE;

   FORALL indx IN employees.FIRST .. employees.LAST
      INSERT
        INTO employee_history (employee_id
                             ,  salary
                             ,  hire_date)
      VALUES (
                employees (indx)
              ,  salaries (indx)
              ,  hire_dates (indx));

   FORALL indx IN employees.FIRST .. employees.LAST
      UPDATE employee
         SET salary = newsal, hire_date = hire_dates (indx)
       WHERE employee_id = employees (indx);
END upd_for_dept2;
/

SHOW ERR

REM Now consider a situation with conditional logic inside loop

CREATE OR REPLACE PROCEDURE upd_for_dept3 (
   dept_in   IN employee.department_id%TYPE
 ,  newsal    IN employee.salary%TYPE)
-- One step with simple loop and conditional logic
IS
   CURSOR emp_cur
   IS
      SELECT employee_id, salary, hire_date
        FROM employee
       WHERE department_id = dept_in;

   emp_rec   emp_cur%ROWTYPE;
BEGIN
   OPEN emp_cur;

   LOOP
      FETCH emp_cur INTO emp_rec;

      EXIT WHEN emp_cur%NOTFOUND;

      IF comp_analysis.eligible (emp_rec.employee_id)
      THEN
         INSERT INTO employee_history (employee_id
                                     ,  salary
                                     ,  hire_date
                                     ,  activity)
              VALUES (emp_rec.employee_id
                    ,  emp_rec.salary
                    ,  emp_rec.hire_date
                    ,  'RAISE GIVEN');

         UPDATE employee
            SET salary = newsal
          WHERE employee_id = emp_rec.employee_id;
      ELSE
         INSERT INTO employee_history (employee_id
                                     ,  salary
                                     ,  hire_date
                                     ,  activity)
              VALUES (emp_rec.employee_id
                    ,  emp_rec.salary
                    ,  emp_rec.hire_date
                    ,  'RAISE DENIED');
      END IF;
   END LOOP;
END upd_for_dept3;
/

SHOW ERR

CREATE OR REPLACE PROCEDURE upd_for_dept4 (
   dept_in   IN employee.department_id%TYPE
 ,  newsal    IN employee.salary%TYPE)
-- Handle conditional logic by partitioning the table.
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
                          INDEX BY BINARY_INTEGER;

   employees             employee_tt;
   approved_employees    employee_tt;
   denied_employees      employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
                        INDEX BY BINARY_INTEGER;

   salaries              salary_tt;
   approved_salaries     salary_tt;
   denied_salaries       salary_tt;

   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
                           INDEX BY BINARY_INTEGER;

   hire_dates            hire_date_tt;
   approved_hire_dates   hire_date_tt;
   denied_hire_dates     hire_date_tt;

   l_row                 PLS_INTEGER;
BEGIN
   SELECT employee_id, salary, hire_date
     BULK COLLECT INTO employees, salaries, hire_dates
     FROM employee
    WHERE department_id = dept_in;

   FOR indx IN employees.FIRST .. employees.LAST
   LOOP
      IF comp_analysis.eligible (employees (indx))
      THEN
         l_row := approved_employees.COUNT + 1;
         approved_employees (l_row) := employees (indx);
         approved_salaries (l_row) := salaries (indx);
         approved_hire_dates (l_row) := hire_dates (indx);
      ELSE
         l_row := denied_employees.COUNT + 1;
         denied_employees (l_row) := employees (indx);
         denied_salaries (l_row) := salaries (indx);
         denied_hire_dates (l_row) := hire_dates (indx);
      END IF;
   END LOOP;

   FORALL indx
       IN approved_employees.FIRST ..
          approved_employees.LAST
     SAVE EXCEPTIONS
      INSERT INTO employee_history (employee_id
                                  ,  salary
                                  ,  hire_date
                                  ,  activity)
           VALUES (approved_employees (indx)
                 ,  approved_salaries (indx)
                 ,  approved_hire_dates (indx)
                 ,  'RAISE GIVEN');

   FORALL indx
       IN denied_employees.FIRST .. denied_employees.LAST
     SAVE EXCEPTIONS
      INSERT INTO employee_history (employee_id
                                  ,  salary
                                  ,  hire_date
                                  ,  activity)
           VALUES (denied_employees (indx)
                 ,  denied_salaries (indx)
                 ,  denied_hire_dates (indx)
                 ,  'RAISE DENIED');

   FORALL indx
       IN approved_employees.FIRST ..
          approved_employees.LAST
     SAVE EXCEPTIONS
      UPDATE employee
         SET salary = newsal
           ,  hire_date = approved_hire_dates (indx)
       WHERE employee_id = approved_employees (indx);
END upd_for_dept4;
/

SHOW ERR

REM And now refactor to improve readability of code

CREATE OR REPLACE PROCEDURE upd_for_dept5 (
   dept_in   IN employee.department_id%TYPE
 ,  newsal    IN employee.salary%TYPE)
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
                          INDEX BY BINARY_INTEGER;

   employees           employee_tt;
   denied_employees    employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
                        INDEX BY BINARY_INTEGER;

   salaries            salary_tt;
   denied_salaries     salary_tt;

   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
                           INDEX BY BINARY_INTEGER;

   hire_dates          hire_date_tt;
   denied_hire_dates   hire_date_tt;

   PROCEDURE retrieve_employee_info
   IS
   BEGIN
      SELECT employee_id, salary, hire_date
        BULK COLLECT INTO employees, salaries, hire_dates
        FROM employee
       WHERE department_id = dept_in;
   END;

   PROCEDURE partition_by_eligibility
   IS
   BEGIN
      FOR indx IN employees.FIRST .. employees.LAST
      LOOP
         IF NOT comp_analysis.eligible (employees (indx))
         THEN
            denied_employees (indx) := employees (indx);
            employees.delete (indx);
            --
            denied_salaries (indx) := salaries (indx);
            salaries.delete (indx);
            --
            denied_hire_dates (indx) := hire_dates (indx);
            hire_dates.delete (indx);
         END IF;
      END LOOP;
   END;

   PROCEDURE add_to_history
   IS
   BEGIN
      FORALL indx IN employees.FIRST .. employees.LAST
         INSERT INTO employee_history (employee_id
                                     ,  salary
                                     ,  hire_date
                                     ,  activity)
              VALUES (employees (indx)
                    ,  salaries (indx)
                    ,  hire_dates (indx)
                    ,  'RAISE GIVEN');

      FORALL indx
          IN denied_employees.FIRST ..
             denied_employees.LAST
         INSERT INTO employee_history (employee_id
                                     ,  salary
                                     ,  hire_date
                                     ,  activity)
              VALUES (denied_employees (indx)
                    ,  denied_salaries (indx)
                    ,  denied_hire_dates (indx)
                    ,  'RAISE DENIED');
   END;

   PROCEDURE give_the_raise
   IS
   BEGIN
      FORALL indx IN employees.FIRST .. employees.LAST
         UPDATE employee
            SET salary = newsal
              ,  hire_date = hire_dates (indx)
          WHERE employee_id = employees (indx);
   END;
BEGIN
   retrieve_employee_info;
   partition_by_eligibility;
   add_to_history;
   give_the_raise;
END upd_for_dept5;
/

SHOW ERR
REM Incremental commit processing with FORALL

CREATE OR REPLACE PROCEDURE upd_for_dept6 (
   dept_in           IN employee.department_id%TYPE
 ,  newsal            IN employee.salary%TYPE
 ,  commit_after_in   IN PLS_INTEGER)
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
                          INDEX BY BINARY_INTEGER;

   employees           employee_tt;
   denied_employees    employee_tt;

   TYPE salary_tt IS TABLE OF employee.salary%TYPE
                        INDEX BY BINARY_INTEGER;

   salaries            salary_tt;
   denied_salaries     salary_tt;

   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
                           INDEX BY BINARY_INTEGER;

   hire_dates          hire_date_tt;
   denied_hire_dates   hire_date_tt;

   PROCEDURE retrieve_employee_info
   IS
   BEGIN
      SELECT employee_id, salary, hire_date
        BULK COLLECT INTO employees, salaries, hire_dates
        FROM employee
       WHERE department_id = dept_in;
   END;

   PROCEDURE partition_by_eligibility
   IS
   BEGIN
      FOR indx IN employees.FIRST .. employees.LAST
      LOOP
         IF NOT comp_analysis.eligible (employees (indx))
         THEN
            denied_employees (indx) := employees (indx);
            employees.delete (indx);
            --
            denied_salaries (indx) := salaries (indx);
            salaries.delete (indx);
            --
            denied_hire_dates (indx) := hire_dates (indx);
            hire_dates.delete (indx);
         END IF;
      END LOOP;
   END;

   PROCEDURE add_to_history (
      commit_after_in IN PLS_INTEGER)
   IS
      l_last    PLS_INTEGER := employees.LAST;
      l_start   PLS_INTEGER := employees.FIRST;
      l_end     PLS_INTEGER;
   BEGIN
      LOOP
         EXIT WHEN l_start > l_last;
         l_end := LEAST (l_start + commit_after_in, l_last);

         FORALL indx IN l_start .. l_end
            INSERT INTO employee_history (employee_id
                                        ,  salary
                                        ,  hire_date
                                        ,  activity)
                 VALUES (employees (indx)
                       ,  salaries (indx)
                       ,  hire_dates (indx)
                       ,  'RAISE GIVEN');

         l_start := l_end + 1;
         COMMIT;
      END LOOP;

      l_last := denied_employees.LAST;
      l_start := denied_employees.FIRST;

      LOOP
         EXIT WHEN l_start > l_last;
         l_end := LEAST (l_start + commit_after_in, l_last);

         FORALL indx IN l_start .. l_end
            INSERT INTO employee_history (employee_id
                                        ,  salary
                                        ,  hire_date
                                        ,  activity)
                 VALUES (denied_employees (indx)
                       ,  denied_salaries (indx)
                       ,  denied_hire_dates (indx)
                       ,  'RAISE DENIED');

         l_start := l_end + 1;
         COMMIT;
      END LOOP;
   END;

   PROCEDURE give_the_raise (
      commit_after_in IN PLS_INTEGER)
   IS
      l_last    PLS_INTEGER := employees.LAST;
      l_start   PLS_INTEGER := employees.FIRST;
      l_end     PLS_INTEGER;
   BEGIN
      LOOP
         EXIT WHEN l_start > l_last;
         l_end := LEAST (l_start + commit_after_in, l_last);

         FORALL indx IN l_start .. l_end
            UPDATE employee
               SET salary = newsal
                 ,  hire_date = hire_dates (indx)
             WHERE employee_id = employees (indx);

         l_start := l_end + 1;
         COMMIT;
      END LOOP;
   END;
BEGIN
   retrieve_employee_info;
   partition_by_eligibility;
   add_to_history (commit_after_in);
   give_the_raise (commit_after_in);
END upd_for_dept6;
/

SHOW ERR