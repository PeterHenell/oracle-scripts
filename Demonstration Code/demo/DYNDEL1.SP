CREATE OR REPLACE PROCEDURE delemps 
   (name_in IN emp.ename%TYPE)
IS   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
BEGIN 
   DBMS_SQL.PARSE (cur,
      'DELETE FROM emp WHERE ename LIKE UPPER (:ename)',
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_VARIABLE (cur, 'ename', name_in);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows deleted: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
sho err
   

