/* simplest example */

DECLARE
   TYPE employee_aat IS TABLE OF employees.employee_id%TYPE
                           INDEX BY PLS_INTEGER;

   l_employees   employee_aat;
BEGIN
   l_employees (1) := 137;
   l_employees (100) := 126;
   l_employees (500) := 147;

   FORALL l_index IN INDICES OF l_employees
      UPDATE employees
         SET salary = 10000
       WHERE employee_id = l_employees (l_index);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   ROLLBACK;
END;
/

SELECT employee_id
  FROM employees
 WHERE salary = 10000
/

DECLARE
   TYPE employee_aat IS TABLE OF employees.employee_id%TYPE
                           INDEX BY PLS_INTEGER;

   l_employees          employee_aat;

   TYPE boolean_aat IS TABLE OF BOOLEAN
                          INDEX BY PLS_INTEGER;

   l_employee_indices   boolean_aat;
BEGIN
   l_employees (1) := 137;
   l_employees (100) := 126;
   l_employees (500) := 147;
   --
   l_employee_indices (1) := FALSE;
   l_employee_indices (500) := TRUE;
   l_employee_indices (799) := NULL;

   --FORALL l_index IN l_employees.FIRST .. l_employees.LAST
   FORALL l_index IN INDICES OF l_employee_indices 
      BETWEEN 1 AND 600
      UPDATE employees
         SET salary = 10000
       WHERE employee_id = l_employees (l_index);
END;
/

SELECT employee_id
  FROM employees
 WHERE salary = 10000
/

ROLLBACK;