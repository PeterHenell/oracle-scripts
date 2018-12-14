CREATE OR REPLACE PROCEDURE updnumval (
   col_in IN VARCHAR2, 
   ename_in IN emp.ename%TYPE, 
   val_in IN NUMBER)
IS   

/* Thames Valley Park 10/98 */

   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   sql_string PLV.dbmaxvc2 := 
      'UPDATE emp SET ' || col_in || ' = ' || val_in || 
         ' WHERE ename LIKE UPPER (' || ename_in || ')';
   fdbk PLS_INTEGER;
BEGIN 
   DBMS_SQL.PARSE (cur, sql_string, DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_SQL.CLOSE_CURSOR (cur);
      p.l (SQLERRM);
      p.l (sql_string);
END;
/

