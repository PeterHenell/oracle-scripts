CREATE OR REPLACE PROCEDURE updnumval
   (col_in IN VARCHAR2,
    start_in IN DATE,
    end_in IN DATE,
    val_in IN NUMBER)
IS
BEGIN
  execute immediate 
      'UPDATE emp SET ' || col_in || ' = ' || val_in ||
      ' WHERE hiredate BETWEEN ' ||
      ' TO_DATE (' || PLVchr.single_quote || TO_CHAR (start_in)  || ''')' ||
      ' AND ' ||
      ' TO_DATE (''' || TO_CHAR (end_in)  || ''')';

   DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || TO_CHAR (fdbk));

   
END;
/


