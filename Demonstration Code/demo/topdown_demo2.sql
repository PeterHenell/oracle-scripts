/*
This is how the call support package looks after the
first round of top-down design and automated refactoring
to create the stub programs.
*/
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

      FUNCTION calls_still_unhandled (temp_in IN VARCHAR2)
         RETURN BOOLEAN
      IS
      BEGIN
         topdown.tbc ('calls_still_unhandled');
         RETURN TRUE;
      END calls_still_unhandled;

      PROCEDURE assign_next_open_call_to (
         employee_id_in IN employees.employee_id%TYPE
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
      WHILE (calls_still_unhandled (NULL))
      LOOP
         FOR emp_rec IN support_dept_cur (department_id_in)
         LOOP
            IF call_analysis.current_caseload (emp_rec.employee_id) <
                       call_analysis.avg_caseload_for_dept (department_id_in)
            THEN
               assign_next_open_call_to
                                       (employee_id_in      => emp_rec.employee_id);
               notify_customer (case_id_in => l_case_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_support_pkg;
/

/*
Now I drill down to assign_next_open_call_to, add stubs there. 
I also clean up the API for calls_still_unhandled (there should be
NO arguments at all). Then I refactor again.
*/
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
         RETURN TRUE;
      END calls_still_unhandled;

      PROCEDURE assign_next_open_call_to (
         employee_id_in IN employees.employee_id%TYPE
      )
      IS
      --topdown.ish
      BEGIN
         topdown.pph ('find_next_open_call|case_id_out:cases.id%type');
         topdown.pph ('assign_to_employee|employee_id_in:employees.employee_id%TYPE:employe_id_in,case_id_out:cases.id%type');
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
               assign_next_open_call_to
                                       (employee_id_in      => emp_rec.employee_id);
               notify_customer (case_id_in => l_case_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_support_pkg;
/
BEGIN
   topdown.refactor (USER, 'CALL_SUPPORT_PKG');
END;
/

/*
And now the call support package looks like this,
after I format it in Toad:
*/

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
         RETURN TRUE;
      END calls_still_unhandled;

      PROCEDURE assign_next_open_call_to (
         employee_id_in IN employees.employee_id%TYPE
      )
      IS
         PROCEDURE find_next_open_call (case_id_out IN cases.ID%TYPE)
         IS
         BEGIN
            topdown.tbc ('find_next_open_call');
         END find_next_open_call;

         PROCEDURE assign_to_employee (
            employee_id_in IN employees.employee_id%TYPE
          , case_id_out IN cases.ID%TYPE
         )
         IS
         BEGIN
            topdown.tbc ('assign_to_employee');
         END assign_to_employee;
      BEGIN
         find_next_open_call (case_id_out => NULL);
         assign_to_employee (employee_id_in      => employe_id_in
                           , case_id_out         => NULL
                            );
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
               assign_next_open_call_to
                                       (employee_id_in      => emp_rec.employee_id);
               notify_customer (case_id_in => l_case_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_support_pkg;
/
