CREATE OR REPLACE PROCEDURE bulkbindall
IS
   cur INTEGER := DBMS_SQL.open_cursor;
   rows_inserted INTEGER;
   
   empnos DBMS_SQL.NUMBER_TABLE;
   enames DBMS_SQL.VARCHAR2_TABLE;
   v_deptno emp.deptno%TYPE;
BEGIN
   DBMS_SQL.parse (
      cur,
      'INSERT INTO emp (empno, deptno, ename)
         VALUES (:empno, :deptno, :ename)',
      DBMS_SQL.native
   );

   v_deptno := 40;
   
   FOR rowind IN 1 .. 1000
   LOOP
      empnos(rowind) := rowind;
      enames(rowind) := 'Steven' || rowind;
   END LOOP;

   DBMS_SQL.bind_array (cur, 'empno', empnos);
   DBMS_SQL.bind_variable (cur, 'deptno', v_deptno);
   DBMS_SQL.bind_array (cur, 'ename', enames);

   rows_inserted := DBMS_SQL.execute (cur);
   
   DBMS_SQL.close_cursor (cur);
END;
/
