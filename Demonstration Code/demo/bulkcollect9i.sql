CREATE OR REPLACE PROCEDURE bulkcollect_9i_demo (whr_in IN VARCHAR2 := NULL)
IS
   TYPE numlist_t IS TABLE OF NUMBER;

   TYPE namelist_t IS TABLE OF VARCHAR2 (100);

   -- New Oracle9i pre-defined REF CURSOR type. This is equivalent to:
   --        TYPE sys_refcursor IS REF CURSOR
   emp_cv   sys_refcursor;
   empnos   numlist_t;
   enames   namelist_t;
   enames_updated   namelist_t;
   ename_filter   namelist_t := namelist_t ('S%', 'E%', 'M%');
   sals     numlist_t;
   l_count PLS_INTEGER;

   bulk_errors EXCEPTION;
   PRAGMA EXCEPTION_INIT ( bulk_errors, -24381 );
BEGIN
   -- Bulk fetch with cursor variable
   OPEN emp_cv FOR 'SELECT empno, ename FROM emp WHERE ' || NVL (whr_in, '1=1');
   FETCH emp_cv BULK COLLECT INTO empnos, enames;
   CLOSE emp_cv;
   
   -- Bulk fetch with "implicit cursor"
   EXECUTE IMMEDIATE 'SELECT sal FROM emp WHERE ' || NVL (whr_in, '1=1')
      BULK COLLECT INTO sals;
   DBMS_OUTPUT.put_line (sals.COUNT);
   
   -- Bulk, dynamic UPDATE
   FORALL indx IN empnos.FIRST .. empnos.LAST
      EXECUTE IMMEDIATE 
        'UPDATE emp SET sal = sal * 1.1 WHERE empno = :employee_key ' ||
        'RETURNING ename INTO :names_updated'
         USING empnos(indx) -- Must specify individual row with FORALL index 
		 RETURNING BULK COLLECT INTO enames_updated; -- Specify collection as whole
		 
   -- Using SQL%BULK_ROWCOUNT: how many rows modified 
   -- by each statement?		 
   FORALL indx IN ename_filter.FIRST .. ename_filter.LAST
      EXECUTE IMMEDIATE 
        'UPDATE emp SET sal = sal * 1.1 
          WHERE ename LIKE :employee_filter'
         USING ename_filter(indx);
		 
   FOR indx IN ename_filter.FIRST .. ename_filter.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE (
	      'Number of employees with names like "' 
      || ename_filter(indx) 
      || '" given a raise: ' || SQL%BULK_ROWCOUNT(indx));
   END LOOP;
END;
/
