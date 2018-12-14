DROP TABLE cases
/
CREATE TABLE cases (ID INTEGER)
/

CREATE OR REPLACE PACKAGE call_analysis
IS
   FUNCTION current_caseload (emp_in IN NUMBER)
      RETURN INTEGER;

   FUNCTION avg_caseload_for_dept (dept_in IN NUMBER)
      RETURN INTEGER;
END call_analysis;
/

CREATE OR REPLACE PACKAGE BODY call_analysis
IS
   FUNCTION current_caseload (emp_in IN NUMBER)
      RETURN INTEGER
   IS
   BEGIN
      RETURN 1;
   END current_caseload;

   FUNCTION avg_caseload_for_dept (dept_in IN NUMBER)
      RETURN INTEGER
   IS
   BEGIN
      RETURN 1;
   END avg_caseload_for_dept;
END call_analysis;
/

CREATE OR REPLACE PACKAGE call_support_pkg
IS
   PROCEDURE distribute_calls (
      department_id_in IN employees.department_id%TYPE
   );
END call_support_pkg;
/

CREATE OR REPLACE PACKAGE BODY call_support_pkg
IS
   PROCEDURE distribute_calls (
      department_id_in IN employees.department_id%TYPE
   )
   IS
      l_case_id   cases.ID%TYPE;

      CURSOR support_dept_cur (
         department_id_in IN employees.department_id%TYPE
      )
      IS
         SELECT *
           FROM employees
          WHERE department_id = department_id_in;

      FUNCTION calls_still_unhandled
         RETURN BOOLEAN
      IS
      BEGIN
         /* Zagreb Sept 2007 */
         topdown.tbc ('calls_still_unhandled');
      END calls_still_unhandled;

      PROCEDURE assign_next_open_call_to (
         employee_id_in IN employees.employee_id%TYPE
       , case_id_out OUT cases.ID%TYPE
      )
      IS
      BEGIN
         topdown.tbc ('assign_next_open_call_to');
      END assign_next_open_call_to;

      PROCEDURE notify_customer (case_id_in IN cases.ID%TYPE)
      IS
      BEGIN
         topdown.tbc ('notify_customer');
      END notify_customer;
   BEGIN
      WHILE (calls_still_unhandled ())
      LOOP
         FOR emp_rec IN support_dept_cur (department_id_in)
         LOOP
            IF call_analysis.current_caseload (emp_rec.employee_id) <
                       call_analysis.avg_caseload_for_dept (department_id_in)
            THEN
               assign_next_open_call_to (emp_rec.employee_id, l_case_id);
               notify_customer (l_case_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_support_pkg;
/

/* Step two .... */

CREATE OR REPLACE PACKAGE BODY call_support_pkg
IS
   PROCEDURE distribute_calls (
      department_id_in IN employees.department_id%TYPE
   )
   IS
      l_case_id   cases.ID%TYPE;

      CURSOR support_dept_cur (
         department_id_in IN employees.department_id%TYPE
      )
      IS
         SELECT *
           FROM employees
          WHERE department_id = department_id_in;

      FUNCTION calls_still_unhandled
         RETURN BOOLEAN
      IS
      BEGIN
         topdown.tbc ('calls_still_unhandled');
         RETURN NULL;
      END calls_still_unhandled;

      PROCEDURE assign_next_open_call_to (
         employee_id_in IN employees.employee_id%TYPE
       , case_id_out OUT cases.ID%TYPE
      )
      IS
         PROCEDURE find_next_open_call (case_out OUT NUMBER)
         IS
         BEGIN
            topdown.tbc ('find_next_open_call');
         END find_next_open_call;

         PROCEDURE assign_to_employee (
            employee_id_in IN NUMBER
          , case_in IN NUMBER
         )
         IS
         BEGIN
            topdown.tbc ('assign_to_employee');
         END assign_to_employee;
      BEGIN
         find_next_open_call (case_id_out);
         assign_to_employee (employee_id_in, case_id_out);
      END assign_next_open_call_to;

      PROCEDURE notify_customer (case_id_in IN cases.ID%TYPE)
      IS
      BEGIN
         topdown.tbc ('notify_customer');
      END notify_customer;
   BEGIN
      WHILE (calls_still_unhandled ())
      LOOP
         FOR emp_rec IN support_dept_cur (department_id_in)
         LOOP
            IF call_analysis.current_caseload (emp_rec.employee_id) <
                       call_analysis.avg_caseload_for_dept (department_id_in)
            THEN
               assign_next_open_call_to (emp_rec.employee_id, l_case_id);
               notify_customer (l_case_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_support_pkg;
/

BEGIN
   topdown.tbc_show;
   call_support_pkg.distribute_calls (15);
END;
/