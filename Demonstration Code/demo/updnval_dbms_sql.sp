CREATE OR REPLACE PROCEDURE updnumval (
   col_in IN VARCHAR2,
   ename_in IN emp.ename%TYPE,
   val_in IN NUMBER)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
   dmlstr PLV.dbmaxvc2 :=
   'UPDATE emp SET ' || col_in || ' = ' || val_in ||
      ' WHERE ename LIKE UPPER (''' || ename_in || ''')';
BEGIN
   DBMS_SQL.PARSE (cur, dmlstr, DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE (
       'Rows updated: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/

