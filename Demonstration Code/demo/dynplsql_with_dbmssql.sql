CREATE OR REPLACE PROCEDURE dyn_plsql (blk IN VARCHAR2)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
   mycode VARCHAR2(100) := 'BEGIN ' || RTRIM (blk, ';') || '; END;';
BEGIN
   p.l (mycode);
   
   DBMS_SQL.PARSE (cur, mycode, DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
