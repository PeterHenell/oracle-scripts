CREATE OR REPLACE PACKAGE return_id_sal
IS
   TYPE employee_rt IS RECORD (
      employee_id   employee.employee_id%TYPE
     ,salary        employee.salary%TYPE
   );

   TYPE employee_rc IS REF CURSOR
      RETURN employee_rt;

   TYPE weak_rc IS REF CURSOR;

   FUNCTION allrows_by (append_to_from_in IN VARCHAR2 DEFAULT NULL)
      RETURN weak_rc; -- Oracle9i: SYS_REFCURSOR;

   FUNCTION allrows_for_dept (
      department_id_in   IN   employee.department_id%TYPE
   )
      RETURN employee_rc;
END return_id_sal;
/

CREATE OR REPLACE PACKAGE BODY return_id_sal
IS
   FUNCTION allrows_by (append_to_from_in IN VARCHAR2 DEFAULT NULL)
      RETURN weak_rc
   IS
      l_return   weak_rc;
   BEGIN
      OPEN l_return FOR    'SELECT EMPLOYEE_ID, SALARY FROM EMPLOYEE '
                        || append_to_from_in;

      RETURN l_return;
   END allrows_by;

   FUNCTION allrows_for_dept (
      department_id_in   IN   employee.department_id%TYPE
   )
      RETURN employee_rc
   IS
      l_return   employee_rc;
   BEGIN
      OPEN l_return FOR
         SELECT employee_id, salary
           FROM employee
          WHERE department_id = department_id_in;

      RETURN l_return;
   END allrows_for_dept;
END return_id_sal;
/

