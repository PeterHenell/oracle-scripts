DROP TABLE cases
/
CREATE TABLE cases (ID INTEGER)
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
   --topdown.ish
   BEGIN
      WHILE (topdown.pfh ('calls_still_unhandled|BOOLEAN'))
      LOOP
         FOR emp_rec IN support_dept_cur (department_id_in)
         LOOP
            IF 
            /*PFH
            current_caseload
            PLS_INTEGER
            employee_id_in:employees.employee_id%TYPE:emp_rec.employee_id
            */
            <
            /*PFH
            avg_caseload_for_dept
            PLS_INTEGER
            department_id_in:departments.department_id%TYPE:emp_rec.department_id
            */
            THEN
               /*PPH
               assign_next_open_call_to
               employee_id_in:employees.employee_id%TYPE:emp_rec.employee_id
               case_id_out:cases.id%type:l_case_id
               */
               topdown.pph ('notify_customer|case_id_in:cases.id%type:l_case_id');
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_support_pkg;
/

BEGIN
   q$error_manager.totable (purge_in => TRUE);
   q$error_manager.set_trace (TRUE);
   topdown.refactor (USER, 'CALL_SUPPORT_PKG');
END;
/

BEGIN
   topdown.tbc_raise;
   call_support_pkg.distribute_calls (60);
END;
/