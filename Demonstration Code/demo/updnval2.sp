CREATE OR REPLACE PROCEDURE updnumval (
   col_in IN VARCHAR2,
   start_in IN DATE,
   end_in IN DATE,
   val_in IN NUMBER)
IS
   cur PLS_INTEGER;
   fdbk PLS_INTEGER;
BEGIN
   cur := DBMS_SQL.OPEN_CURSOR; /* TVP 9/99 */
   
   DBMS_SQL.PARSE (cur,
      'UPDATE emp SET ' || col_in || ' = :val 
        WHERE hiredate BETWEEN :lodate AND :hidate',
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_VARIABLE (cur, 'val', val_in);
   DBMS_SQL.BIND_VARIABLE (cur, 'lodate', start_in);
   DBMS_SQL.BIND_VARIABLE (cur, 'hidate', end_in);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || TO_CHAR (fdbk));
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/

