DECLARE
   l_var        PLS_INTEGER  DEFAULT 100;

   CURSOR emp_cur
   IS
      SELECT *
        FROM employee;

   TYPE emp_rc IS REF CURSOR
      RETURN employee%ROWTYPE;

   emp_cv       emp_rc;

   TYPE employee_aat IS TABLE OF employee%ROWTYPE
      INDEX BY BINARY_INTEGER;

   l_employee   employee_aat;

   PROCEDURE plsb (
      str   IN   VARCHAR2
    , val   IN   BOOLEAN
    , len   IN   PLS_INTEGER DEFAULT 80
   )
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
   OPEN emp_cur;

   LOOP
      FETCH emp_cur
      BULK COLLECT INTO l_employee LIMIT 1000;

      EXIT WHEN emp_cur%NOFOUND
	  --
      l_row := l_employee.FIRST;

      WHILE (l_row IS NOT NULL)
      LOOP
         DBMS_OUTPUT.PUT_LINE (l_employee (l_row));
         l_row := l_employee.NEXT (l_row);
      END LOOP;
   -- Process the data
   END LOOP;

   CLOSE emp_cur;

   /*Buffer overflow!

   DBMS_OUTPUT.put_line ('Check emp_cur%ROWCOUNT...');

   OPEN emp_cur;

   LOOP
      FETCH emp_cur
      BULK COLLECT INTO l_employee LIMIT 10;

      DBMS_OUTPUT.put_line (   '...Retrieved 10 rows. %ROWCOUNT = '
                            || emp_cur%ROWCOUNT
                           );
      EXIT WHEN emp_cur%ROWCOUNT < 10;
      -- Process the data
      l_employee.DELETE;
   END LOOP;

   CLOSE emp_cur;*/
   DBMS_OUTPUT.put_line ('Check %FOUND and %NOTFOUND...');

   OPEN emp_cur;

   LOOP
      FETCH emp_cur
      BULK COLLECT INTO l_employee LIMIT 10;

      plsb ('...Retrieved ' || l_employee.COUNT || ' rows. %FOUND = '
          , emp_cur%FOUND
           );
      plsb ('...Retrieved ' || l_employee.COUNT || ' rows. %NOTFOUND = '
          , emp_cur%NOTFOUND
           );
      EXIT WHEN emp_cur%NOTFOUND;
   -- Process the data
   END LOOP;

   CLOSE emp_cur;

   DBMS_OUTPUT.put_line ('Check %FOUND and %NOTFOUND with REF CURSOR...');

   OPEN emp_cv FOR
      SELECT *
        FROM employee;

   LOOP
      FETCH emp_cv
      BULK COLLECT INTO l_employee LIMIT 10;

      plsb ('...Retrieved 10 rows. %FOUND = ', emp_cv%FOUND);
      plsb ('...Retrieved 10 rows. %NOTFOUND = ', emp_cv%NOTFOUND);
      EXIT WHEN emp_cv%NOTFOUND;
   -- Process the data
   END LOOP;

   CLOSE emp_cv;
END;
/

/* Results
Delete and check collection count...
...Retrieved 10 rows. Collection count = 10
...Retrieved 10 rows. Collection count = 10
...Retrieved 10 rows. Collection count = 10
...Retrieved 10 rows. Collection count = 2
...Retrieved 10 rows. Collection count = 0
Check %FOUND and %NOTFOUND...
...Retrieved 10 rows. %FOUND =  - TRUE
...Retrieved 10 rows. %NOTFOUND =  - FALSE
...Retrieved 10 rows. %FOUND =  - TRUE
...Retrieved 10 rows. %NOTFOUND =  - FALSE
...Retrieved 10 rows. %FOUND =  - TRUE
...Retrieved 10 rows. %NOTFOUND =  - FALSE
...Retrieved 2 rows. %FOUND =  - FALSE
...Retrieved 2 rows. %NOTFOUND =  - TRUE
Check %FOUND and %NOTFOUND with REF CURSOR...
...Retrieved 10 rows. %FOUND =  - TRUE
...Retrieved 10 rows. %NOTFOUND =  - FALSE
...Retrieved 10 rows. %FOUND =  - TRUE
...Retrieved 10 rows. %NOTFOUND =  - FALSE
...Retrieved 10 rows. %FOUND =  - TRUE
...Retrieved 10 rows. %NOTFOUND =  - FALSE
...Retrieved 10 rows. %FOUND =  - FALSE
...Retrieved 10 rows. %NOTFOUND = 
*/
