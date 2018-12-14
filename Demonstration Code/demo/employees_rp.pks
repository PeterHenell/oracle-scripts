CREATE OR REPLACE PACKAGE employee_rp
AS
   c_min_ceo_salary   CONSTANT PLS_INTEGER := 10000000;

   SUBTYPE fullname_t IS VARCHAR2 (1000);

   CURSOR emps_in_dept_cur (department_id_in IN employees.department_id%TYPE)
   IS
      SELECT employee_id, salary, last_name, first_name
        FROM employees
       WHERE department_id = department_id_in;

   FUNCTION fullname (
      l                 employees.last_name%TYPE
    , f                 employees.first_name%TYPE
    , use_f_l_in   IN   BOOLEAN := FALSE
   )
      RETURN fullname_t;

   FUNCTION fullname_i (
      l                 employees.last_name%TYPE
    , f                 employees.first_name%TYPE
    , use_f_l_in   IN   PLS_INTEGER := 0
   )
      RETURN fullname_t;

   FUNCTION fullname (
      employee_id_in   IN   employees.employee_id%TYPE
    , use_f_l_in       IN   BOOLEAN := FALSE
   )
      RETURN fullname_t;

   FUNCTION fullname_explicit (
      employee_id_in   IN   employees.employee_id%TYPE
    , use_f_l_in       IN   BOOLEAN := FALSE
   )
      RETURN fullname_t;

   FUNCTION fullname_twosteps (
      employee_id_in   IN   employees.employee_id%TYPE
    , use_f_l_in       IN   BOOLEAN := FALSE
   )
      RETURN fullname_t;
END employee_rp;
/