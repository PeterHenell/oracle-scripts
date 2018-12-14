DROP TABLE employees_m2
/

CREATE TABLE employees_m2
AS
   SELECT * FROM employees
/

/* Single bind variable */

CREATE OR REPLACE PROCEDURE set_to_10000 (
   col_in             IN VARCHAR2,
   department_id_in   IN PLS_INTEGER)
IS
   l_update   VARCHAR2 (1000)
      :=    'UPDATE employees_m2 SET '
         || col_in
         || ' = 10000 
        WHERE department_id = :dept';
BEGIN
   EXECUTE IMMEDIATE l_update USING department_id_in;

   DBMS_OUTPUT.put_line ('Rows updated: ' || TO_CHAR (SQL%ROWCOUNT));
END;
/

DECLARE
   l_count   INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM employees_m2
    WHERE department_id = 50 AND salary = 10000;

   DBMS_OUTPUT.put_line ('Before ' || l_count);
   set_to_10000 ('salary', 50);

   SELECT COUNT (*)
     INTO l_count
     FROM employees_m2
    WHERE department_id = 50 AND salary = 10000;

   DBMS_OUTPUT.put_line ('After ' || l_count);
   ROLLBACK;
END;
/

/* Multiple bind variables */

CREATE OR REPLACE PROCEDURE updnumval (
   col_in             IN VARCHAR2,
   department_id_in   IN PLS_INTEGER,
   val_in             IN NUMBER)
IS
   l_update   VARCHAR2 (1000)
      :=    'UPDATE employees_m2 SET '
         || col_in
         || ' = :val 
        WHERE department_id = :dept';
BEGIN
   EXECUTE IMMEDIATE l_update USING val_in, department_id_in;

   DBMS_OUTPUT.put_line ('Rows updated: ' || TO_CHAR (SQL%ROWCOUNT));
END;
/

DECLARE
   l_count   INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM employees_m2
    WHERE department_id = 50 AND salary = 10000;

   DBMS_OUTPUT.put_line ('Before ' || l_count);
   set_to_10000 ('salary', 50);

   SELECT COUNT (*)
     INTO l_count
     FROM employees_m2
    WHERE department_id = 50 AND salary = 10000;

   DBMS_OUTPUT.put_line ('After ' || l_count);
   ROLLBACK;
END;
/

/* Reference same bind variable more than once.

   Must supply value both times.
*/

CREATE OR REPLACE PROCEDURE set_to_10000 (
   col_in             IN VARCHAR2,
   department_id_in   IN PLS_INTEGER,
   val_in             IN NUMBER)
IS
   l_update   VARCHAR2 (1000)
      :=    'UPDATE employees_m2 SET '
         || col_in
         || ' = :val 
        WHERE department_id = :dept and :val IS NOT NULL';
BEGIN
   EXECUTE IMMEDIATE l_update USING val_in, department_id_in, val_in;

   DBMS_OUTPUT.put_line ('Rows updated: ' || TO_CHAR (SQL%ROWCOUNT));
END;
/

DECLARE
   l_count   INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM employees_m2
    WHERE department_id = 50 AND salary = 10000;

   DBMS_OUTPUT.put_line ('Before ' || l_count);
   set_to_10000 ('salary', 50, 10000);

   SELECT COUNT (*)
     INTO l_count
     FROM employees_m2
    WHERE department_id = 50 AND salary = 10000;

   DBMS_OUTPUT.put_line ('After ' || l_count);
   ROLLBACK;
END;
/