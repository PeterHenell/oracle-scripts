CREATE OR REPLACE PACKAGE myvars
IS
   empno emp.empno%TYPE;
   deptno emp.deptno%TYPE;
   ename emp.ename%TYPE;
END;
/

CREATE OR REPLACE PROCEDURE loadlots4 (
   tab IN VARCHAR2)
IS
BEGIN
   FOR rowind IN 1 .. 1000
   LOOP
      myvars.empno := rowind;               
      myvars.deptno := GREATEST (10 * MOD (rowind, 4), 10);                
      myvars.ename := 'Steven' || rowind;

      EXECUTE IMMEDIATE
         'BEGIN 
             INSERT INTO ' || tab || '(empno, deptno, ename)
               VALUES (myvars.empno, myvars.deptno, myvars.ename);
          END;';      
   END LOOP;
END;
/
