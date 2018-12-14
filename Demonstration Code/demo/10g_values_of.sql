SELECT employee_id
  FROM employees
 WHERE salary = 10000
/

DECLARE
   TYPE employee_aat IS TABLE OF employees.employee_id%TYPE
      INDEX BY PLS_INTEGER;

   l_employees          employee_aat;

   TYPE values_aat IS TABLE OF PLS_INTEGER
      INDEX BY PLS_INTEGER;

   l_employee_values   values_aat;
BEGIN
   l_employees (-77) := 134;
   l_employees (13067) := 123;
   l_employees (99999999) := 147;
   l_employees (1070) := 129;
   --
   l_employee_values (100) := -77;
   l_employee_values (200) := 13067;
   l_employee_values (300) := 1070;
   --
   FORALL l_index IN VALUES OF l_employee_values
      UPDATE employees
         SET salary = 10000
       WHERE employee_id = l_employees (l_index);
   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

SELECT employee_id
  FROM employees
 WHERE salary = 10000
/

ROLLBACK ;