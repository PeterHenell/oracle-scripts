/*
   Which of these blocks display "TMR" after execution?
*/

CREATE TABLE plch_employees
(
   employee_id   INTEGER PRIMARY KEY
 ,  last_name     VARCHAR2 (100)
 ,  salary        NUMBER
)
/

BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      INSERT INTO plch_employees
           VALUES (indx, 'Employee' || indx, 1000);
   END LOOP;

   COMMIT;
END;
/

/* Not with BULK COLLECT */

DECLARE
   l_names   DBMS_SQL.varchar2_table;
BEGIN
   SELECT last_name
     BULK COLLECT INTO l_names
     FROM plch_employees;
EXCEPTION
   WHEN TOO_MANY_ROWS
   THEN
      DBMS_OUTPUT.put_line ('TMR');
END;
/

/* Certainly with SELECT INTO */

DECLARE
   l_name   plch_employees.last_name%TYPE;
BEGIN
   SELECT last_name INTO l_name FROM plch_employees;
EXCEPTION
   WHEN TOO_MANY_ROWS
   THEN
      DBMS_OUTPUT.put_line ('TMR');
END;
/

/* RETURNING as well */

DECLARE
   l_employee_id   plch_employees.employee_id%TYPE;
BEGIN
      UPDATE plch_employees
         SET salary = salary * 1.1
       WHERE last_name LIKE 'Employee1%'
   RETURNING employee_id
        INTO l_employee_id;
EXCEPTION
   WHEN TOO_MANY_ROWS
   THEN
      DBMS_OUTPUT.put_line ('TMR');
END;
/

/* Dynamic SQL, too */

DECLARE
   c_table   CONSTANT VARCHAR2 (30) := 'PLCH_EMPLOYEES';
   l_name             plch_employees.last_name%TYPE;
BEGIN
   EXECUTE IMMEDIATE 'SELECT last_name FROM ' || c_table INTO l_name;
EXCEPTION
   WHEN TOO_MANY_ROWS
   THEN
      DBMS_OUTPUT.put_line ('TMR');
END;
/

/* Clean up */

DROP TABLE plch_employees
/