DECLARE
   c_limit   CONSTANT PLS_INTEGER DEFAULT 25;

   CURSOR emp_cur
   IS
      SELECT * FROM employees;

   TYPE emp_rc IS REF CURSOR
      RETURN employees%ROWTYPE;

   emp_cv             emp_rc;

   TYPE employee_aat IS TABLE OF employees%ROWTYPE
                           INDEX BY BINARY_INTEGER;

   l_employee         employee_aat;

   PROCEDURE plsb (str   IN VARCHAR2
                 , val   IN BOOLEAN
                 , len   IN PLS_INTEGER DEFAULT 80)
   IS
   BEGIN
      IF val
      THEN
         DBMS_OUTPUT.put_line (str || ' - TRUE');
      ELSIF NOT val
      THEN
         DBMS_OUTPUT.put_line (str || ' - FALSE');
      ELSE
         DBMS_OUTPUT.put_line (str || ' - NULL');
      END IF;
   END plsb;
BEGIN
   DBMS_OUTPUT.put_line ('Fetch ' || c_limit || ' at a time...');

   OPEN emp_cur;

   LOOP
      FETCH emp_cur
      BULK COLLECT INTO l_employee
      LIMIT c_limit;

      EXIT WHEN l_employee.COUNT = 0;

      DBMS_OUTPUT.put_line ('Retrieved ' || l_employee.COUNT);

      FOR indx IN 1 .. l_employee.COUNT
      LOOP
         NULL; -- process_data (l_employee (indx));
      END LOOP;
   END LOOP;

   CLOSE emp_cur;

   DBMS_OUTPUT.put_line ('Check %FOUND and %NOTFOUND...');

   OPEN emp_cur;

   LOOP
      FETCH emp_cur
      BULK COLLECT INTO l_employee
      LIMIT c_limit;

      plsb ('...Retrieved ' || l_employee.COUNT || ' rows. %FOUND = '
          , emp_cur%FOUND);
      plsb ('...Retrieved ' || l_employee.COUNT || ' rows. %NOTFOUND = '
          , emp_cur%NOTFOUND);
      EXIT WHEN emp_cur%NOTFOUND;
   -- Process the data
   END LOOP;

   CLOSE emp_cur;

   DBMS_OUTPUT.put_line ('Check %FOUND and %NOTFOUND with REF CURSOR...');

   OPEN emp_cv FOR SELECT * FROM employees;

   LOOP
      FETCH emp_cv
      BULK COLLECT INTO l_employee
      LIMIT c_limit;

      plsb ('...Retrieved ' || c_limit || ' rows. %FOUND = ', emp_cv%FOUND);
      plsb ('...Retrieved ' || c_limit || ' rows. %NOTFOUND = '
          , emp_cv%NOTFOUND);
      EXIT WHEN emp_cv%NOTFOUND;
   -- Process the data
   END LOOP;

   CLOSE emp_cv;
END;
/

