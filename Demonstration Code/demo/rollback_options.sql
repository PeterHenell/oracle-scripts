DROP TABLE employees_temp
/

CREATE TABLE employees_temp
AS
   SELECT *
     FROM employees
/

BEGIN
   DELETE FROM employees_temp;
   DBMS_STANDARD.rollback_nr;
   SAVEPOINT SAVEPOINT_NAME;   
   DBMS_STANDARD.rollback_sv ('SAVEPOINT_NAME');
END;
/