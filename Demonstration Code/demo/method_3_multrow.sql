/* Define a collection of records and with a single 
   EXECUTE IMMEDIATE copy all elements from table into 
   collection.
*/

DECLARE
   TYPE employee_ntt IS TABLE OF employees%ROWTYPE;

   l_employees   employee_ntt;
BEGIN
   EXECUTE IMMEDIATE 'SELECT * FROM employees' BULK COLLECT INTO l_employees;

   DBMS_OUTPUT.put_line (l_employees.COUNT);
END allrows_by;
/

/* Do the same thing used a cursor variable and OPEN FOR */

DECLARE
   CV            SYS_REFCURSOR;

   TYPE employee_ntt IS TABLE OF employees%ROWTYPE;

   l_employees   employee_ntt;
BEGIN
   OPEN CV FOR 'SELECT * FROM employees';

   FETCH CV
   BULK COLLECT INTO l_employees;

   DBMS_OUTPUT.put_line (l_employees.COUNT);

   CLOSE CV;
END allrows_by;
/

/* And use the LIMIT clause with BULK COLLECT */

DECLARE
   CV            SYS_REFCURSOR;

   TYPE employee_ntt IS TABLE OF employees%ROWTYPE;

   l_employees   employee_ntt;
BEGIN
   OPEN CV FOR 'SELECT * FROM employees';

   LOOP
      FETCH CV
      BULK COLLECT INTO l_employees
      LIMIT 100;

      EXIT WHEN l_employees.COUNT = 0;

      DBMS_OUTPUT.put_line (l_employees.COUNT);
   END LOOP;

   CLOSE CV;
END allrows_by;
/