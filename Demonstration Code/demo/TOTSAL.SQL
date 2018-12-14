set timing on
CREATE VIEW dept_sal 
AS
   SELECT deptno, SUM (sal) total_sal
     FROM emp
 GROUP BY deptno;
 
 CREATE OR REPLACE FUNCTION total_sal 
   (dept_id_in IN dept.deptno%TYPE)
  RETURN NUMBER
IS
  CURSOR total_cur IS 
    SELECT SUM (sal) total_sal
      FROM dept D, emp E
     WHERE D.deptno = E.deptno (+)
       AND D.deptno = dept_id_in;
  retval NUMBER;
BEGIN
  OPEN total_cur; 
  FETCH total_cur INTO retval;
  IF total_cur%NOTFOUND THEN
    retval := NULL;
  END IF;
  CLOSE total_cur;
  RETURN retval;
END total_sal;
/
CREATE OR REPLACE FUNCTION max_sal 
   (dept_id_in IN dept.deptno%TYPE)
  RETURN NUMBER
IS
  CURSOR total_cur IS 
    SELECT MAX (sal) max_sal
      FROM dept D, emp E
     WHERE D.deptno = E.deptno (+)
       AND D.deptno = dept_id_in;
  retval NUMBER;
BEGIN
  OPEN total_cur; 
  FETCH total_cur INTO retval;
  IF total_cur%NOTFOUND THEN
    retval := NULL;
  END IF;
  CLOSE total_cur;
  RETURN retval;
END MAX_sal;
/
ttitle 'With View'
 SELECT E.deptno, ename, sal, total_sal
  FROM emp E, dept_sal DS
 WHERE E.deptno = DS.deptno
   AND sal = 
     (SELECT MAX (sal) 
        FROM emp E2
       WHERE E2.deptno = E.deptno)
 ORDER BY E.deptno, ename;
ttitle 'With PL/SQL' 
 SELECT deptno, 
       ename, sal, 
       total_sal (deptno)
  FROM emp
 WHERE sal = max_sal (deptno)
 ORDER BY deptno, ename;
 