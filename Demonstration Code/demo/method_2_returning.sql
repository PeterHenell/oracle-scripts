/* Make sure tabcount_nds.sf has been run */

DROP TABLE employees_m2
/

CREATE TABLE employees_m2
AS
   SELECT * FROM employees
/

/* Single row changed */

CREATE OR REPLACE PROCEDURE set_one_row (
   col_in           IN VARCHAR2
 ,  employee_id_in   IN PLS_INTEGER)
IS
   l_update   VARCHAR2 (1000)
      :=    'UPDATE employees_m2 SET '
         || col_in
         || ' = 10000 
        WHERE employee_id = :empid
        RETURNING last_name INTO :the_name';
   l_name     VARCHAR2 (100);
BEGIN
   EXECUTE IMMEDIATE l_update
      USING IN employee_id_in
      RETURNING INTO l_name;

   DBMS_OUTPUT.put_line ('Name updated: ' || l_name);
END;
/

BEGIN
   set_one_row ('salary', 138);
   ROLLBACK;
END;
/

/* Multiple rows changed */

CREATE OR REPLACE PROCEDURE set_multiple_rows (
   col_in             IN VARCHAR2
 ,  department_id_in   IN PLS_INTEGER)
IS
   l_update   VARCHAR2 (1000)
      :=    'UPDATE employees_m2 SET '
         || col_in
         || ' = 10000 
        WHERE department_id = :deptid
        RETURNING last_name INTO :the_name';
   l_name     VARCHAR2 (100);
BEGIN
   EXECUTE IMMEDIATE l_update
      USING IN department_id_in
      RETURNING INTO l_name;

   DBMS_OUTPUT.put_line ('Name updated: ' || l_name);
END;
/

BEGIN
   set_multiple_rows ('salary', 50);
   /* ORA-01422: exact fetch returns more than requested number of rows */
   ROLLBACK;
END;
/

/* Need to BULK COLLECT INTO ... */

CREATE OR REPLACE PROCEDURE set_multiple_rows (
   col_in             IN VARCHAR2
 ,  department_id_in   IN PLS_INTEGER)
IS
   l_update   VARCHAR2 (1000)
      :=    'UPDATE employees_m2 SET '
         || col_in
         || ' = 10000 
        WHERE department_id = :deptid
        RETURNING last_name INTO :the_name';

   l_names    DBMS_SQL.varchar2a;
BEGIN
   EXECUTE IMMEDIATE l_update
      USING IN department_id_in
      RETURNING BULK COLLECT INTO l_names;

   DBMS_OUTPUT.put_line ('Name updated: ' || l_names.COUNT);
END;
/

BEGIN
   set_multiple_rows ('salary', 50);
   ROLLBACK;
END;
/