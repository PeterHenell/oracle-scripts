CREATE OR REPLACE PROCEDURE loadlots1 (
   tab IN VARCHAR2)
IS
   cur PLS_INTEGER;
   rows_inserted PLS_INTEGER;
BEGIN
   FOR rowind IN 1 .. 1000
   LOOP
      cur := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE (
         cur,
         'INSERT INTO ' || tab || '(empno, deptno, ename)
             VALUES (:empno, :deptno, :ename)',
         DBMS_SQL.native
      );
      DBMS_SQL.BIND_VARIABLE (cur, 'empno', rowind);
      DBMS_SQL.BIND_VARIABLE (cur, 'deptno', GREATEST (10 * MOD (rowind, 4), 10));
      DBMS_SQL.BIND_VARIABLE (cur, 'ename', 'Steven' || rowind);
      rows_inserted := DBMS_SQL.EXECUTE (cur);
      DBMS_SQL.CLOSE_CURSOR (cur);
   END LOOP;
END;
/
