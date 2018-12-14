CREATE OR REPLACE TYPE idlist_t IS TABLE OF INTEGER;
/

CREATE OR REPLACE PROCEDURE put_in_table (n_in IN idlist_t)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'drop table empno_temp';
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE 'create table empno_temp (empid INTEGER)';

   FORALL indx IN 1 .. n_in.COUNT
      EXECUTE IMMEDIATE 'insert into empno_temp values (:empno)'
         USING n_in (indx);

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
      RAISE;
END;
/

DECLARE
   TYPE namelist_t IS TABLE OF employees.last_name%TYPE;

   ename_filter   namelist_t := namelist_t ('S%', 'E%', '%A%');
   empnos         idlist_t;
BEGIN
   /* If I don't use constructor I have to do all this:
   ename_filter.extend (3);
   ename_filter (1) := 'S%';
   ename_filter (2) := 'E%';
   ename_filter (3) := '%A%';
   */

   -- Using SQL%BULK_ROWCOUNT: how many rows modified
   -- by each statement?

   FORALL indx IN 1 .. ename_filter.COUNT
         UPDATE employees
            SET salary = salary * 1.1
          WHERE UPPER (last_name) LIKE ename_filter (indx)
      RETURNING employee_id
           BULK COLLECT INTO empnos;

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);

   FOR indx IN 1 .. ename_filter.COUNT
   --FOR indx IN 1 .. SQL%BULK_ROWCOUNT.count
   LOOP
      DBMS_OUTPUT.put_line (
            'Number of employees with names like "'
         || ename_filter (indx)
         || '" given a raise: '
         || SQL%BULK_ROWCOUNT (indx));
   END LOOP;

   DBMS_OUTPUT.put_line (empnos.COUNT || ' rows modifed!');
   ROLLBACK;

   FOR indx IN 1 .. empnos.COUNT
   LOOP
      DBMS_OUTPUT.put_line (empnos (indx));
   END LOOP;

   put_in_table (empnos);
   
/*
BEGIN
   EXECUTE IMMEDIATE 'drop table empno_temp';
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;

EXECUTE IMMEDIATE    'create table empno_temp (empid INTEGER)'
                  || ' as select * from table (:empnos)'
            USING empnos;
*/
END;
/