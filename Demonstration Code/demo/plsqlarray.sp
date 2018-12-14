CREATE OR REPLACE PROCEDURE testarray
IS
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;
   mytab1 DBMS_SQL.NUMBER_TABLE;
   mytab2 DBMS_SQL.NUMBER_TABLE;
BEGIN
   mytab1 (25) := 100;
   mytab1 (100) := 1000;
   mytab2 (25) := -100;
   mytab2 (100) := -1000;
   DBMS_SQL.PARSE (cur, 'BEGIN :newtab := :oldtab; END;', DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_ARRAY (cur, 'newtab', mytab2, 25, 100);
   DBMS_SQL.BIND_ARRAY (cur, 'oldtab', mytab1, 25, 100);

   fdbk := DBMS_SQL.EXECUTE (cur);
   
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
exec testarray
