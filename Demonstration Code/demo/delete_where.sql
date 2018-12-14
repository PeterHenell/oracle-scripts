SPOOL delete_where.log

CONNECT hr/hr
SET serveroutput on
SET echo on

DROP TABLE employees2
/
CREATE TABLE employees2 AS SELECT * FROM employees
/
SELECT COUNT (*) "HR COUNT BEFORE"
  FROM employees2
/
GRANT SELECT ON employees2 TO SCOTT
/

CREATE OR REPLACE PROCEDURE delete_table (
   table_in IN VARCHAR2
 , where_in IN VARCHAR2 DEFAULT NULL
)
AUTHID DEFINER
IS
BEGIN
   DBMS_OUTPUT.put_line ('Deleting from ' || table_in || '...');

   EXECUTE IMMEDIATE    'DELETE FROM '
                     || table_in
                     || CASE
                           WHEN where_in IS NULL
                              THEN NULL
                           ELSE ' WHERE ' || where_in
                        END;
END delete_table;
/

GRANT EXECUTE ON delete_table TO scott
/
/* Connect to SCOTT */

CONNECT scott/tiger
SET serveroutput on
SET echo on

DROP TABLE employees2
/
CREATE TABLE employees2 AS SELECT * FROM hr.employees2
/
DROP TABLE employees3
/
CREATE TABLE employees3 AS SELECT * FROM hr.employees2
/
SELECT COUNT (*) "SCOTT.EMPLOYEES2 COUNT BEFORE"
  FROM employees2
/
SELECT COUNT (*) "SCOTT.EMPLOYEES3 COUNT BEFORE"
  FROM employees3
/

BEGIN
   hr.delete_table ('employees2');
END;
/

BEGIN
   hr.delete_table ('employees3');
END;
/

BEGIN
   hr.delete_table ('SCOTT.employees3');
END;
/

SELECT COUNT (*) "SCOTT.EMPLOYEES2 COUNT AFTER"
  FROM employees2
/
SELECT COUNT (*) "SCOTT.EMPLOYEES3 COUNT AFTER"
  FROM employees3
/

SELECT COUNT (*) "HR COUNT AFTER"
  FROM HR.employees2
/
/* 
*
* Now change to invoker rights and do it again. 
*
*/

CONNECT hr/hr
SET serveroutput on
SET echo on

DROP TABLE employees2
/
CREATE TABLE employees2 AS SELECT * FROM employees
/
SELECT COUNT (*) "HR COUNT BEFORE"
  FROM employees2
/
GRANT SELECT ON employees2 TO scott
/

CREATE OR REPLACE PROCEDURE delete_table (
   table_in IN VARCHAR2
 , where_in IN VARCHAR2 DEFAULT NULL
)
AUTHID CURRENT_USER              /* The only line of code that has changed! */
IS
BEGIN
   DBMS_OUTPUT.put_line ('Deleting from ' || table_in || '...');

   EXECUTE IMMEDIATE    'DELETE FROM '
                     || table_in
                     || CASE
                           WHEN where_in IS NULL
                              THEN NULL
                           ELSE ' WHERE ' || where_in
                        END;
END delete_table;
/

GRANT EXECUTE ON delete_table TO scott
/
/* Connect to SCOTT */

CONNECT scott/tiger
SET serveroutput on
SET echo on

DROP TABLE employees2
/
CREATE TABLE employees2 AS SELECT * FROM hr.employees2
/
DROP TABLE employees3
/
CREATE TABLE employees3 AS SELECT * FROM hr.employees2
/
SELECT COUNT (*) "SCOTT.EMPLOYEES2 COUNT BEFORE"
  FROM employees2
/
SELECT COUNT (*) "SCOTT.EMPLOYEES3 COUNT BEFORE"
  FROM employees3
/

BEGIN
   hr.delete_table ('employees2');
END;
/

SELECT COUNT (*) "SCOTT.EMPLOYEES2 COUNT AFTER"
  FROM employees2
/

BEGIN
   hr.delete_table ('employees3');
END;
/

SELECT COUNT (*) "SCOTT.EMPLOYEES3 COUNT AFTER"
  FROM employees3
/

BEGIN
   hr.delete_table ('HR.employees2');
END;
/

SELECT COUNT (*) "HR.EMPLOYEES2 COUNT AFTER"
  FROM HR.employees2
/

SPOOL OFF