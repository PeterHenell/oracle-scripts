CREATE OR REPLACE PROCEDURE bulk_rowcount_demo
IS
   TYPE idlist_t IS TABLE OF employees.employee_id%TYPE;

   TYPE namelist_t IS TABLE OF employees.last_name%TYPE;
   type r is record (n number, v varchar2(1000));
   type t is table of r;
   rr t := t();

   ename_filter namelist_t := namelist_t ( 'S%', 'E%', '%A%' );
   empnos idlist_t :=  idlist_t ();
BEGIN
   -- Using SQL%BULK_ROWCOUNT: how many rows modified
   -- by each statement?
   FORALL indx IN ename_filter.FIRST .. ename_filter.LAST
      UPDATE    employees
            SET salary = salary * 1.1
          WHERE UPPER ( last_name ) LIKE ename_filter ( indx )
      RETURNING         employee_id, last_name
      BULK COLLECT INTO rr;
   --
   DBMS_OUTPUT.put_line ( SQL%ROWCOUNT );

   FOR indx IN ename_filter.FIRST .. ename_filter.LAST
   LOOP
      DBMS_OUTPUT.put_line (    'Number of employees with names like "'
                             || ename_filter ( indx )
                             || '" given a raise: '
                             || SQL%BULK_ROWCOUNT ( indx )
                           );
   END LOOP;

   DBMS_OUTPUT.put_line ( empnos.COUNT || ' rows modifed!' );
   ROLLBACK;

   FOR indx IN 1 .. empnos.COUNT
   LOOP
      DBMS_OUTPUT.put_line ( empnos ( indx ));
   END LOOP;

   EXECUTE IMMEDIATE 'drop table empno_temp';
   EXECUTE IMMEDIATE 'create table empno_temp (empid INTEGER)';

   FORALL indx IN 1 .. empnos.COUNT
      EXECUTE IMMEDIATE 'insert into empno_temp values (:empno)'
                  USING empnos ( indx );
END;
/
