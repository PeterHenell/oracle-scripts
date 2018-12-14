CREATE OR REPLACE PROCEDURE method4_bind_variables (
   sql_in            IN VARCHAR2
 , placeholders_in   IN DBMS_SQL.varchar2a
 , values_in         IN DBMS_SQL.varchar2a)
IS
   l_cursor     INTEGER := DBMS_SQL.open_cursor;
   l_feedback   PLS_INTEGER;
BEGIN
   DBMS_SQL.parse (l_cursor, sql_in, DBMS_SQL.native);

   FOR indx IN 1 .. values_in.COUNT
   LOOP
      DBMS_SQL.bind_variable (l_cursor
                            , placeholders_in (indx)
                            , values_in (indx));
   END LOOP;

   l_feedback := DBMS_SQL.execute (l_cursor);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   
   DBMS_SQL.close_cursor (l_cursor);
END;
/

DECLARE
   l_placeholders   DBMS_SQL.varchar2a;
   l_values         DBMS_SQL.varchar2a;
   l_sum            PLS_INTEGER;
BEGIN
   SELECT SUM (salary)
     INTO l_sum
     FROM employees
    WHERE department_id = 50;

   DBMS_OUTPUT.put_line ('Before: ' || l_sum);

   l_placeholders (2) := 'DEPARTMENT_ID';
   l_placeholders (1) := 'SALARY';
   l_values (2) := '50';
   l_values (1) := '10000';

   method4_bind_variables (
      'update employees set salary = :salary 
        where department_id = :department_id'
    , l_placeholders
    , l_values);

   SELECT SUM (salary)
     INTO l_sum
     FROM employees
    WHERE department_id = 50;

   DBMS_OUTPUT.put_line ('After: ' || l_sum);
   ROLLBACK;
END;
/