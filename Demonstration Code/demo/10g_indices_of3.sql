CREATE OR REPLACE PROCEDURE forall_indices_of
IS
   TYPE employee_aat IS TABLE OF employee.employee_id%TYPE
      INDEX BY PLS_INTEGER;

   l_employees employee_aat;
BEGIN
   l_employees ( 1 ) := 7839;
   l_employees ( 100 ) := 7654;
   l_employees ( 500 ) := 7950;
   --
   FORALL l_index IN INDICES OF l_employees
      UPDATE employee
         SET salary = 10000
       WHERE employee_id = l_employees ( l_index );
END forall_indices_of;
/

CREATE OR REPLACE PROCEDURE forall_sequential
IS
   TYPE employee_aat IS TABLE OF employee.employee_id%TYPE
      INDEX BY PLS_INTEGER;

   l_employees employee_aat;
BEGIN
   l_employees ( 1 ) := 7839;
   l_employees ( 2 ) := 7654;
   l_employees ( 3 ) := 7950;
   --
   FORALL l_index IN l_employees.FIRST .. l_employees.LAST
      UPDATE employee
         SET salary = 10000
       WHERE employee_id = l_employees ( l_index );
END forall_sequential;
/