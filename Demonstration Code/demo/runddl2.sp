CREATE OR REPLACE PROCEDURE runddl (ddl_in in VARCHAR2)
IS
   cur INTEGER:= DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;
BEGIN
   DBMS_SQL.PARSE (cur, ddl_in, DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_SQL.CLOSE_CURSOR (cur);
EXCEPTION
   WHEN OTHERS
   THEN
      fdbk := DBMS_SQL.LAST_ERROR_POSITION;
      DBMS_OUTPUT.PUT_LINE (
         SQLERRM || CHR(10) ||
         ddl_in || CHR(10) ||
         LPAD ('^', fdbk+1, '-')); 
      DBMS_SQL.CLOSE_CURSOR (cur);
      RAISE;
END;
/
GRANT EXECUTE ON runDDL to PUBLIC;
