CREATE OR REPLACE PROCEDURE bindall
IS
   cur INTEGER := DBMS_SQL.open_cursor;
   rows_inserted INTEGER;

BEGIN
   DBMS_SQL.parse (
      cur,
      'INSERT INTO emp (empno, deptno, ename)
         VALUES (:empno, :deptno, :ename)',
      DBMS_SQL.native
   );

   FOR rowind IN 1 .. 1000
   LOOP
      DBMS_SQL.bind_variable (cur, 'empno', rowind);
      DBMS_SQL.bind_variable (cur, 'deptno', 40);
      DBMS_SQL.bind_variable (cur, 'ename', 'Steven' || rowind);
      rows_inserted := DBMS_SQL.execute (cur);
   END LOOP;

   DBMS_SQL.close_cursor (cur);
END;
/
