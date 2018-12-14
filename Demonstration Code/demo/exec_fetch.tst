CREATE OR REPLACE PROCEDURE PROCEDURE exec_fetch (
   val IN INTEGER, exact_match IN BOOLEAN := FALSE)
IS
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;
BEGIN
   DBMS_SQL.PARSE
     (cur, 'SELECT empno FROM emp where 1=' || val, DBMS_SQL.NATIVE);

   DBMS_SQL.DEFINE_COLUMN (cur, 1, 1);

   fdbk := DBMS_SQL.EXECUTE_AND_FETCH (cur, exact_match);
   p.l (fdbk);
   DBMS_SQL.CLOSE_CURSOR (cur);
EXCEPTION
   WHEN OTHERS
   THEN
      p.l (SQLCODE);
      DBMS_SQL.COLUMN_VALUE (cur, 1, fdbk);
      p.l (fdbk);
END;
/
