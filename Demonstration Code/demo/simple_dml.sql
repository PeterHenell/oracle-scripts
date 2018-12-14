/*

Execute "simple" DML and then check rows modified

*/

DECLARE
   l_table   VARCHAR2 (30) := 'employees';
BEGIN
   EXECUTE IMMEDIATE 'UPDATE ' || l_table || ' SET salary = salary * 1.25';

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
   ROLLBACK;
END;
/