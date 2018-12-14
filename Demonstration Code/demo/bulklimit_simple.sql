DECLARE
   CURSOR emp_cur
   IS
      SELECT *
        FROM employees;

   TYPE employees_aat IS TABLE OF employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_employees employees_aat;
BEGIN
   OPEN emp_cur;

   LOOP
      FETCH emp_cur
      BULK COLLECT INTO l_employees LIMIT 100;

      EXIT WHEN l_employees.COUNT = 0;

      FOR indx IN 1 .. l_employees.COUNT
      LOOP
         process_employee ( l_employees ( l_row ));
      END LOOP;
   END LOOP;

   CLOSE emp_cur;
END;
/
