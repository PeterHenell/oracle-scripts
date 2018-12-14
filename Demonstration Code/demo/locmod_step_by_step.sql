/* Step 1. Implement the executive summary as main executable section: 

Function calls_are_unhandled: 
   takes no arguments, returns TRUE if there is still at 
   least one unhandled call, FALSE otherwise.
   
Function current_caseload: 
   returns the number of calls (case load) assigned to that employee.
   
Function avg_caseload_for_dept: 
   returns the average number of calls assigned to employees in that department.
   
Procedure assign_next_open_call: 
   assigns the employee to the call, making it handled, as opposed to unhandled. 

*/

CREATE OR REPLACE PACKAGE BODY call_manager
IS
   /*
      Lots of existing programs here including show_caseload.
   */
   PROCEDURE show_caseload (
      department_id_in IN departments.department_id%TYPE ... END;

   /* The new program */
   PROCEDURE distribute_calls (
      department_id_in IN departments.department_id%TYPE
   )
   IS
   BEGIN
      WHILE (calls_are_unhandled ())
      LOOP
         FOR emp_rec IN emps_in_dept_cur (department_id_in)
         LOOP
            IF current_caseload (emp_rec.employee_id) <
                                     avg_caseload_for_dept (department_id_in)
            THEN
               assign_next_open_call (emp_rec.employee_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_manager;
/

/* Step 2. Implement stubs for each of the subprograms. */

CREATE OR REPLACE PACKAGE BODY call_manager
IS
   /*
      Lots of existing programs here including show_caseload.
   */
   PROCEDURE show_caseload (
      department_id_in IN departments.department_id%TYPE ... END;

   /* The new program */
   PROCEDURE distribute_calls (
      department_id_in IN departments.department_id%TYPE
   )
   IS
      FUNCTION calls_are_handled
         RETURN BOOLEAN
      IS
      BEGIN
         RETURN NULL;
      END calls_are_handled;

      FUNCTION current_caseload (employee_id_in IN employees.employee_id%TYPE)
         RETURN PLS_INTEGER
      IS
      BEGIN
         RETURN NULL;
      END current_caseload;

      FUNCTION avg_caseload_for_dept (
         employee_id_in IN employees.employee_id%TYPE
      )
         RETURN PLS_INTEGER
      IS
      BEGIN
         RETURN NULL;
      END current_caseload;

      PROCEDURE assign_next_open_call (
         employee_id_in IN employees.employee_id%TYPE
      )
      IS
      BEGIN
         NULL;
      END assign_next_open_call;
   BEGIN
      WHILE (calls_are_unhandled ())
      LOOP
         FOR emp_rec IN emps_in_dept_cur (department_id_in)
         LOOP
            IF current_caseload (emp_rec.employee_id) <
                                     avg_caseload_for_dept (department_id_in)
            THEN
               assign_next_open_call (emp_rec.employee_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_manager;
/

/* Step 3: Deja Vu coding! The feeling I have written this before.
           I wrote something that sounds like current_caseload in
           the call_manager.show_caseload program I wrote last week.
           
           So I will extract that code and place it at the package
           body level so both show_caseload and distribute_calls can
           use it. I will also need to add another argument to the
           parameter list for backward compatibility. Finally, I
           remove the local stub with that same name.
*/

CREATE OR REPLACE PACKAGE BODY call_manager
IS
   FUNCTION current_caseload (
      employee_id_in IN employees.employee_id%TYPE
    , use_in_show_in IN BOOLEAN DEFAULT TRUE
   )
      RETURN PLS_INTEGER
   IS
   BEGIN
      /* Assume real implementation here... */
      IF use_in_show_in
      THEN
         NULL;
      ELSE
         NULL;
      END IF;

      RETURN NULL;
   END current_caseload;

   PROCEDURE show_caseload (
      department_id_in IN departments.department_id%TYPE
   )
   IS
      l_currload   PLS_INTEGER;
   BEGIN
      /* Assume real implementation here... */
      l_currload :=
                  current_caseload (department_id_in, use_in_show_in => TRUE);
   END show_caseload;

   PROCEDURE distribute_calls (
      department_id_in IN departments.department_id%TYPE
   )
   IS
      FUNCTION calls_are_handled
         RETURN BOOLEAN
      IS
      BEGIN
         RETURN NULL;
      END calls_are_handled;

      FUNCTION avg_caseload_for_dept (
         employee_id_in IN employees.employee_id%TYPE
      )
         RETURN PLS_INTEGER
      IS
      BEGIN
         RETURN NULL;
      END current_caseload;

      PROCEDURE assign_next_open_call (
         employee_id_in IN employees.employee_id%TYPE
      )
      IS
      BEGIN
         NULL;
      END assign_next_open_call;
   BEGIN
      WHILE (calls_are_unhandled ())
      LOOP
         FOR emp_rec IN emps_in_dept_cur (department_id_in)
         LOOP
            IF current_caseload (emp_rec.employee_id) <
                                     avg_caseload_for_dept (department_id_in)
            THEN
               assign_next_open_call (emp_rec.employee_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END;
/

/* Step 4: Leverage the work of others in our team. The challenge here
           of course is how to even KNOW that this other code exists.
           But just suppose we know. Replace the local program with
           the pre-defined program.
*/

CREATE OR REPLACE PACKAGE call_util
IS
   FUNCTION dept_avg_caseload (
      department_id_in IN departments.department_id%TYPE
   )
      RETURN PLS_INTEGER;
END call_util;
/

CREATE OR REPLACE PACKAGE BODY call_manager
IS
   /*
      Lots of existing programs here including show_caseload
      AND the new current_caseload.
   */

   /* The new program */
   PROCEDURE distribute_calls (
      department_id_in IN departments.department_id%TYPE
   )
   IS
      FUNCTION calls_are_handled
         RETURN BOOLEAN
      IS
      BEGIN
         RETURN NULL;
      END calls_are_handled;

      PROCEDURE assign_next_open_call (
         employee_id_in IN employees.employee_id%TYPE
      )
      IS
      BEGIN
         NULL;
      END assign_next_open_call;
   BEGIN
      WHILE (calls_are_unhandled ())
      LOOP
         FOR emp_rec IN emps_in_dept_cur (department_id_in)
         LOOP
            IF current_caseload (emp_rec.employee_id) <
                               call_util.dept_avg_caseload (department_id_in)
            THEN
               assign_next_open_call (emp_rec.employee_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_manager;
/

/* Step 5: Build out the next level of detail down, but again stick to stubs. 
           Also, this step assumes that we a generated API (Change Package
           and Query Package and Types Package) on which we will build out
           our code.
*/

CREATE OR REPLACE PACKAGE BODY call_manager
IS
   /*
      Lots of existing programs here including show_caseload
      AND the new current_caseload.
   */

   /* The new program */
   PROCEDURE distribute_calls (
      department_id_in IN departments.department_id%TYPE
   )
   IS
      FUNCTION calls_are_handled
         RETURN BOOLEAN
      IS
      BEGIN
         RETURN NULL;
      END calls_are_handled;

      PROCEDURE assign_next_open_call (
         employee_id_in IN employees.employee_id%TYPE
      )
      IS
         /* This is just a stub... */
         
         FUNCTION next_open_call RETURN cm_call_tp.cm_call_rt
         IS
         BEGIN
            RETURN NULL;
         END next_open_call;
      BEGIN
         l_call := next_open_call ();
         l_call.employee_id := employee_id_in;
         cm_call_cp.ins (l_call);
      END assign_next_open_call;
   BEGIN
      WHILE (calls_are_unhandled ())
      LOOP
         FOR emp_rec IN emps_in_dept_cur (department_id_in)
         LOOP
            IF current_caseload (emp_rec.employee_id) <
                               call_util.dept_avg_caseload (department_id_in)
            THEN
               assign_next_open_call (emp_rec.employee_id);
            END IF;
         END LOOP;
      END LOOP;
   END distribute_calls;
END call_manager;
/

/* Steps 6, 7, 8...Continue the iterative process of defining 
   the next layer down until you are done. */