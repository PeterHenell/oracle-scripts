CREATE OR REPLACE PROCEDURE updsal 
   (start_in IN DATE, end_in IN DATE,
    sal_in IN emp.sal%TYPE)
IS   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
BEGIN                                           
   DBMS_SQL.PARSE (cur,
      'UPDATE emp SET sal = ' || sal_in || 
      ' WHERE hiredate BETWEEN :lodate AND :hidate',
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_VARIABLE (cur, 'lodate', start_in);
   DBMS_SQL.BIND_VARIABLE (cur, 'hidate', end_in);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
sho err
   
