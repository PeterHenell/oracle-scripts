CREATE OR REPLACE PROCEDURE updemps 
   (enametab IN DBMS_SQL.VARCHAR2_TABLE,
    saltab IN DBMS_SQL.NUMBER_TABLE)
IS   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
BEGIN 
   DBMS_SQL.PARSE (cur,
      'UPDATE emp SET sal = :sal WHERE ename LIKE UPPER (:ename)',
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_ARRAY (cur, 'sal', saltab);
   DBMS_SQL.BIND_ARRAY (cur, 'ename', enametab);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
sho err
   
