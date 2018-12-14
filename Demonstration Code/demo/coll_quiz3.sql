DECLARE
   CURSOR emp_cur
   IS
      SELECT *
        FROM employee;

   TYPE employee_aat IS TABLE OF employee%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_employees   employee_aat;
BEGIN
   OPEN emp_cur;

   LOOP
      FETCH emp_cur
      BULK COLLECT INTO l_employees LIMIT 1000;

      EXIT WHEN emp_cur%NOTFOUND;
      --
      process_rows (l_employees);
   END LOOP;

   CLOSE emp_cur;
END;
