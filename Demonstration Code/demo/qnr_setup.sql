CONNECT SYSTEM/SYSTEM;

DROP USER qnr_test CASCADE;

CREATE USER qnr_test IDENTIFIED BY qnr_test;

GRANT RESOURCE, CONNECT TO qnr_test;

GRANT CREATE PUBLIC SYNONYM, DROP PUBLIC SYNONYM TO qnr_test;
GRANT SELECT ON scott.EMP TO qnr_test;
GRANT SELECT ON scott.DEPT TO qnr_test;

CONNECT QNR_TEST/QNR_TEST;

CREATE TABLE qnr_test.EMP
AS SELECT * FROM scott.EMP;

CREATE TABLE qnr_test.DEPT
AS SELECT * FROM scott.DEPT;

CREATE OR REPLACE VIEW qnr_test.vemp (department, empqty)
AS
   SELECT   d.dname
           ,COUNT (e.empno)
       FROM qnr_test.DEPT d, EMP e
      WHERE d.deptno = e.deptno
   GROUP BY d.dname;

CREATE OR REPLACE PACKAGE qnr_test.Pkg
IS
   FUNCTION fmult (a NUMBER, b NUMBER)
      RETURN NUMBER;

   PROCEDURE pmult (a NUMBER, b NUMBER);
END Pkg;
/

CREATE OR REPLACE PACKAGE BODY qnr_test.Pkg
IS
   PROCEDURE pmult (a NUMBER, b NUMBER)
   IS
      res   NUMBER;
   BEGIN
      res := a * b;
      DBMS_OUTPUT.put_line ('PMult:  ' || a || '*' || b || '=' || res);
   END;

   FUNCTION fmult (a NUMBER, b NUMBER)
      RETURN NUMBER
   IS
      retval   NUMBER;
   BEGIN
      retval := a * b;
      RETURN (retval);
   END;
END Pkg;
/

CREATE OR REPLACE FUNCTION qnr_test.Func (a NUMBER, b NUMBER)
   RETURN NUMBER
IS
   RESULT   NUMBER;
BEGIN
   RESULT := a + b;
   RETURN (RESULT);
END Func;
/

CREATE OR REPLACE PROCEDURE qnr_test.Proc (a NUMBER, b NUMBER)
IS
   res   NUMBER;
BEGIN
   res := a + b;
   DBMS_OUTPUT.put_line ('proc:     ' || a || '+' || b || '=' || res);
END Proc;
/

CREATE OR REPLACE TYPE qnr_test.objt AS OBJECT (
   -- The type has 3 attributes.
   LENGTH   NUMBER
  ,width    NUMBER
  ,area     NUMBER
  ,
   -- Define a constructor that has only 2 parameters.
   CONSTRUCTOR FUNCTION objt (LENGTH NUMBER, width NUMBER)
      RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY qnr_test.objt
AS
   CONSTRUCTOR FUNCTION objt (LENGTH NUMBER, width NUMBER)
      RETURN SELF AS RESULT
   AS
   BEGIN
      SELF.LENGTH := LENGTH;
      SELF.width := width;
      -- We compute the area rather than accepting it as a parameter.
      SELF.area := LENGTH * width;
      RETURN;
   END;
END;
/
