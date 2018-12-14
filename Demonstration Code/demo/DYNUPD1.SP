CREATE OR REPLACE PROCEDURE updsal 
   (ename_in IN emp.ename%TYPE,
    sal_in IN emp.sal%TYPE,
    tab_in IN VARCHAR2)
IS   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
BEGIN 
   DBMS_SQL.PARSE (cur,
      'UPDATE ' || tab_in || ' SET sal = ' || sal_in || 
      ' WHERE ename LIKE UPPER (' || ename_in || ')',
      DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
sho err
   
