/* BEFORE */

CREATE OR REPLACE PROCEDURE process_employee (department_id IN NUMBER)
IS
   l_id        NUMBER;
   l_dollars   NUMBER;
   l_name      VARCHAR2 (100);

   /* Full name: LAST COMMA FIRST (ReqDoc 123.A.47) */
   CURSOR emps_in_dept_cur
   IS
      SELECT employee_id, salary, last_name || ',' || first_name l_name
        FROM employees
       WHERE department_id = department_id;
BEGIN
   OPEN emps_in_dept_cur;

   LOOP
      FETCH emps_in_dept_cur
       INTO l_id, l_dollars, l_name;

      analyze_compensation (l_id, l_dollars);

      UPDATE employees
         SET salary = l_dollars
       WHERE employee_id = employee_id;

      EXIT WHEN emps_in_dept_cur%NOTFOUND;
   END LOOP;
END;

/* AFTER */

/* Now I have an RP (rules package) with the full name logic.
   See the fullname.pks/pkb files for a complete implementation. */

CREATE OR REPLACE PACKAGE employees_rp
AS
   SUBTYPE fullname_t IS VARCHAR2 (1000);

   TYPE fullnames_aat IS TABLE OF fullname_t
      INDEX BY PLS_INTEGER;

   FUNCTION fullname (
      l employees.last_name%TYPE
    , f employees.first_name%TYPE
   )
      RETURN fullname_t;
END employees_rp;
/

/* Just a portion of the QP package */

CREATE OR REPLACE PACKAGE employees_qp
AS
   FUNCTION ar_emp_dept_fk (department_id_in IN employees_tp.department_id_t)
      RETURN employees_tp.employees_tc;
END employees_qp;
/

/* The XP package with the custom update procedure */

CREATE OR REPLACE PACKAGE employees_xp
AS
   bulk_errors   EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);

   PROCEDURE update_salaries (employees_in employees_tp.employees_tc);
END employees_xp;
/

CREATE OR REPLACE PACKAGE BODY employees_xp
AS
   PROCEDURE update_salaries (employees_in employees_tp.employees_tc)
   IS
      l_employee_ids   employees_tp.employee_id_cc;
      l_salaries       employees_tp.salary_cc;
   BEGIN
      /* Move data to column-level collections, for use in FORALL. */
      FOR indx IN 1 .. employees_in.COUNT
      LOOP
         l_employee_ids (indx) := employees_in (indx).employee_id;
         l_salaries (indx) := employees_in (indx).salary;
      END LOOP;

      /* Push the data back to the database. */
      FORALL indx IN 1 .. employees_in.COUNT SAVE EXCEPTIONS
         UPDATE employees
            SET salary = l_salaries (indx)
          WHERE employee_id = l_employees_ids (indx);
   EXCEPTION
      WHEN bulk_errors
      THEN
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
         LOOP
            log_error;
         END LOOP;
   END update_salaries;
END employees_xp;
/

/* The application-level code */

CREATE OR REPLACE PACKAGE hr_compensation
IS
   PROCEDURE adjust_salaries (department_id_in IN employees_tp.department_id_t);
END hr_compensation;
/

CREATE OR REPLACE PACKAGE BODY hr_compensation
IS
   PROCEDURE report_and_adjust (
      fullname_in IN employee_rp.fullname_t
    , employee_id_in IN employee_tp.employee_id_t
    , salary_in IN employee_tp.salary_t
   )
   IS
   BEGIN
      /* Enough already! Just a dummy placeholder, OK? */
      NULL;
   END report_and_adjust;

   PROCEDURE adjust_salaries (department_id_in IN employees_tp.department_id_t)
   IS
      l_employees   employees_tp.employees_tc;
      l_fullnames   employees_rp.fullname_aat;
   BEGIN
      /* Retrieve the "raw" data. */
      l_employees := employees_qp.ar_emp_dept_fk (department_id_in);

      /* Construct the fullname for each employee. */
      FOR indx IN 1 .. l_employees.COUNT
      LOOP
         l_fullnames (indx) :=
            employee_rp.fullname (l_employees (indx).first_name
                                , l_employees (indx).last_name
                                 );
      END LOOP;

      /* Adjust the salary, pass fullname for reporting purposes. */
      FOR indx IN 1 .. l_employees.COUNT
      LOOP
         report_and_adjust (l_fullnames (indx)
                          , l_employees (indx).employee_id
                          , l_employees (indx).salary
                           );
      END LOOP;

      employees_xp.update_salaries (l_employees);
   END adjust_salaries;
END hr_compensation;
/