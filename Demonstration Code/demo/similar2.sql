REM
REM How many distinct SQL statements (and PL/SQL blocks) are  
REM parsed when this code is run?
REM

SELECT ename, sal 
  FROM EMP
 WHERE deptno = 10 AND ename LIKE 'S%';

SELECT ename, sal FROM EMP
   WHERE deptno = 10 AND ename LIKE 'S%';

DECLARE
   rec EMP%ROWTYPE;
   v_dept INTEGER := 10;
   v_name VARCHAR2(100) := 'S%';
BEGIN
   FOR rec IN (
      SELECT ename, sal 
        FROM EMP
       WHERE deptno = 10 AND ename LIKE 'S%')
   LOOP
      NULL;
   END LOOP;

   FOR rec IN (SELECT ename, sal 
   FROM
   EMP WHERE deptno = 10 AND ename LIKE 'S%')
   LOOP
      NULL;
   END LOOP;
   
   FOR rec IN (SELECT ename, sal 
   FROM
   EMP WHERE deptno = v_dept AND ename LIKE v_name)
   LOOP
      NULL;
   END LOOP;
   
END;
/  
DECLARE
   CURSOR ename IS SELECT * FROM EMP;
BEGIN
   p.l(1);
END;
/
DECLARE
   CURSOR ENAME IS SELECT * FROM EMP;
BEGIN
   P.L(1);
END;
/
