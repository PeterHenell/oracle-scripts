CREATE OR REPLACE PROCEDURE delemps 
   (enametab IN DBMS_SQL.VARCHAR2_TABLE)
IS   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
BEGIN 
   DBMS_SQL.PARSE (cur,
      'DELETE FROM emp WHERE ename LIKE UPPER (:ename)',
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_ARRAY (cur, 'ename', enametab);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows deleted: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
sho err
   
