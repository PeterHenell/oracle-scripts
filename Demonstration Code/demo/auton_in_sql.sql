DROP TABLE employees_temp
/

CREATE TABLE employees_temp
AS
   SELECT *
     FROM employees
/

SELECT COUNT ( * )
  FROM employees_temp
/

CREATE OR REPLACE FUNCTION nasty_function
   RETURN PLS_INTEGER
IS
BEGIN
   DELETE FROM employees_temp;

   COMMIT;
   RETURN 1;
END;
/

DECLARE
   l_distinct   PLS_INTEGER;
BEGIN
   SELECT COUNT (nasty_function ())
     INTO l_distinct
     FROM employees;

   DBMS_OUTPUT.put_line ('Count in employees: '|| l_distinct);
END;
/

CREATE OR REPLACE FUNCTION nasty_function
   RETURN PLS_INTEGER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   DELETE FROM employees_temp;

   COMMIT;
   RETURN 1;
END;
/

DECLARE
   l_distinct   PLS_INTEGER;
BEGIN
   SELECT COUNT (nasty_function ())
     INTO l_distinct
     FROM employees;

   DBMS_OUTPUT.put_line ('Count in employees: '|| l_distinct);
END;
/

DROP TABLE employees_temp
/