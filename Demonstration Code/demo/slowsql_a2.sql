CREATE OR REPLACE PACKAGE myvars
IS
   empno emp.empno%TYPE;
   deptno emp.deptno%TYPE;
   ename emp.ename%TYPE;
END;
/

CREATE OR REPLACE PROCEDURE bindnone
IS
   cur INTEGER := DBMS_SQL.open_cursor;
   rows_inserted INTEGER;
BEGIN
   DBMS_SQL.parse (
      cur,
      'BEGIN
          INSERT INTO emp (empno, deptno, ename)
            VALUES (myvars.empno, myvars.deptno, myvars.ename);
       END;',
      DBMS_SQL.native
   );

   FOR rowind IN 1 .. 1000
   LOOP
      myvars.empno := rowind;
      myvars.deptno := 40;
      myvars.ename := 'Steven' || rowind;
      rows_inserted := DBMS_SQL.execute (cur);
   END LOOP;
   DBMS_SQL.close_cursor (cur);
END;
/                   
