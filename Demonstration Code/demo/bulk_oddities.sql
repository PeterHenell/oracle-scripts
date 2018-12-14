CREATE OR REPLACE PROCEDURE bulk_oddities 
   (deptno_in IN dept.deptno%TYPE)
IS
   TYPE three_cols_rt IS RECORD (
      empno emp.empno%TYPE,
      ename emp.ename%TYPE,
      hiredate emp.hiredate%TYPE);
      
   TYPE three_cols_tt IS TABLE OF 
      three_cols_rt INDEX BY PLS_INTEGER;
      
   three_cols_t three_cols_tt;

   TYPE numTab IS TABLE OF NUMBER;
   TYPE charTab IS TABLE OF VARCHAR2(12);
   TYPE dateTab IS TABLE OF DATE;
   enos numTab;
   names charTab;
   hdates dateTab;
      
   CURSOR three_cols_cur IS 
   SELECT empno, ename, hiredate
      FROM emp
     WHERE deptno = deptno_in;
     
     
BEGIN 
   -- Can fetch into collection of records,
   -- but cannot put LIMIT on BULK COLLECT implicit fetch.
   SELECT empno, ename, hiredate
      BULK COLLECT INTO three_cols_t 
      FROM emp
     WHERE deptno = deptno_in;

   -- This will not compile
   /*
   SELECT empno, ename, hiredate
      BULK COLLECT INTO three_cols_t 
      FROM emp
     WHERE deptno = deptno_in
     LIMIT 100;
   */
   
   -- I can place a limit with a FETCH statement
   -- but it won't let me fetch into collection of records.
   
   OPEN three_cols_cur;
   FETCH three_cols_cur 
      BULK COLLECT INTO enos, names, hdates 
      LIMIT 100;
      
   /*
   OPEN three_cols_cur;
   FETCH three_cols_cur 
      BULK COLLECT INTO three_cols_t 
      LIMIT 100;
   */
END;

