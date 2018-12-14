SELECT employee_id FROM employees  WHERE salary = 10000;

DECLARE
   TYPE employee_aat IS TABLE OF employees.employee_id%TYPE
      INDEX BY PLS_INTEGER;
	  
   l_employees           employee_aat;
BEGIN
   l_employees (1) := 7839;
   l_employees (100) := 7654;
   l_employees (500) := 7950;
   --
   FORALL l_index IN INDICES OF l_employees
      between 100 and 500
      UPDATE employees
         SET salary = 10000
       WHERE employee_id = l_employees (l_index);
END;
/

SELECT employee_id FROM employees  WHERE salary = 10000;

ROLLBACK;