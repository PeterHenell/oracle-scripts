DECLARE
   TYPE employee_aat IS TABLE OF employees.employee_id%TYPE
                           INDEX BY PLS_INTEGER;

   l_employees          employee_aat;

   TYPE boolean_aat IS TABLE OF BOOLEAN
                          INDEX BY PLS_INTEGER;

   l_employee_indices   boolean_aat;
   l_index2             PLS_INTEGER;
BEGIN
   l_employees (1) := 200;
   l_employees (100) := 100;
   l_employees (500) := 300;
   --
   l_employee_indices (1) := FALSE;
   l_employee_indices (500) := TRUE;
   l_employee_indices (799) := NULL;

   --
   --FORALL l_index IN l_employees.FIRST .. l_employees.LAST
   FORALL l_index IN INDICES OF l_employee_indices BETWEEN 1 AND 500
      UPDATE employees
         SET salary = 10000
       WHERE employee_id = l_employees (l_index);

   l_index2 := l_employee_indices.FIRST;

   WHILE l_index2 IS NOT NULL
   LOOP
      IF l_index2 BETWEEN 1 AND 500
      THEN
         DBMS_OUTPUT.put_line (SQL%BULK_ROWCOUNT (l_index2));
      END IF;

      l_index2 := l_employee_indices.NEXT (l_index2);
   END LOOP;
END;
/