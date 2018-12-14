CREATE OR REPLACE PROCEDURE updnumval
   (col_in IN VARCHAR2,
    start_in IN DATE,
    end_in IN DATE,
    val_in IN NUMBER)
IS
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
BEGIN
   DBMS_SQL.PARSE (cur, 
      'UPDATE emp SET ' || col_in || ' = ' || val_in ||
      ' WHERE hiredate BETWEEN ' ||
      ' TO_DATE (''' || TO_CHAR (start_in)  || ''')' ||
      ' AND ' ||
      ' TO_DATE (''' || TO_CHAR (end_in)  || ''')' ,
      DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/


