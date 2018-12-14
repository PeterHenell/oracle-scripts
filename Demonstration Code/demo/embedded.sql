DROP VIEW dept_salary;

CREATE VIEW dept_salary 
AS
   SELECT deptno, SUM (sal) total_salary
     FROM emp
 GROUP BY deptno;

CREATE OR REPLACE FUNCTION totsal 
   (dept_id_in IN dept.deptno%TYPE)
  RETURN NUMBER
IS
  CURSOR grpcur IS 
    SELECT SUM (sal) totsal
      FROM emp
     WHERE deptno = dept_id_in;

  grprec grpcur%ROWTYPE;

BEGIN
  OPEN grpcur; 
  FETCH grpcur INTO grprec;
  RETURN grprec.totsal;

END totsal;
/

CREATE OR REPLACE FUNCTION maxsal 
   (dept_id_in IN dept.deptno%TYPE)
  RETURN NUMBER
IS
  CURSOR grpcur IS 
    SELECT MAX(sal) maxsal
      FROM emp
     WHERE deptno = dept_id_in;

  grprec grpcur%ROWTYPE;

BEGIN
  OPEN grpcur; 
  FETCH grpcur INTO grprec;
  RETURN grprec.maxsal;

END maxsal;
/
