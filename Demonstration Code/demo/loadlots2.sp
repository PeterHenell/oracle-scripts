CREATE OR REPLACE PROCEDURE loadlots2 (
   tab IN VARCHAR2)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   rows_inserted PLS_INTEGER;
BEGIN
   DBMS_SQL.parse (
      cur,
      'INSERT INTO ' || tab || '(empno, deptno, ename)
          VALUES (:empno, :deptno, :ename)',
      DBMS_SQL.native
   );

   FOR rowind IN 1 .. 1000
   LOOP
      DBMS_SQL.BIND_VARIABLE (cur, 'empno', rowind);
      DBMS_SQL.BIND_VARIABLE (cur, 'deptno', GREATEST (10 * MOD (rowind, 4), 10));
      DBMS_SQL.BIND_VARIABLE (cur, 'ename', 'Steven' || rowind);
      rows_inserted := DBMS_SQL.EXECUTE (cur);
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
