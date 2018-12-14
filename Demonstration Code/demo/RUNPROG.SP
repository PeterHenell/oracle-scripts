CREATE OR REPLACE PROCEDURE testdyn (in1 IN NUMBER, in2 IN DATE, out1 OUT NUMBER)
IS
BEGIN
   out1 := in1 + TO_NUMBER (TO_CHAR (in2, 'YYYY'));
END;
/
CREATE OR REPLACE PROCEDURE runproc 
   (proc IN VARCHAR2, arglist IN VARCHAR2, outval OUT NUMBER)
IS
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;
BEGIN
   DBMS_SQL.PARSE
     (cur, 'BEGIN ' || proc || '(' || arglist || ', :outparam); END;', 
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_VARIABLE (cur, 'outparam', 1);

   fdbk := DBMS_SQL.EXECUTE (cur);
   
   DBMS_SQL.VARIABLE_VALUE (cur, 'outparam', outval);
   
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
DECLARE
   n NUMBER;
BEGIN
    runproc ('testdyn', '1, sysdate', n);
    DBMS_OUTPUT.PUT_LINE (n);
END;
/
