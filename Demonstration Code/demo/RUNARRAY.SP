/* DOES NOT WORK! */

CREATE OR REPLACE PROCEDURE testdyn (in1 IN NUMBER, in2 IN DATE, out1 OUT DBMS_SQL.NUMBER_TABLE)
IS
BEGIN
   FOR ind IN 1986 .. 1997
   LOOP
      out1(ind) := in1 + TO_NUMBER (TO_CHAR (in2, 'YYYY')) - ind;
   END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE runarray 
   (proc IN VARCHAR2, arglist IN VARCHAR2, outval IN OUT DBMS_SQL.NUMBER_TABLE)
IS
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;
   mytab DBMS_SQL.NUMBER_TABLE;
BEGIN
   DBMS_SQL.PARSE
     (cur, 'BEGIN ' || proc || '(' || arglist || ', :outparam); END;', 
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_ARRAY (cur, 'outparam', outval);

   fdbk := DBMS_SQL.EXECUTE (cur);
   dbms_output.put_line (fdbk);
   --DBMS_SQL.VARIABLE_VALUE (cur, 'outparam', mytab);
   
   DBMS_SQL.CLOSE_CURSOR (cur);
   
   --outval := mytab;
END;
/
DECLARE
   localtab DBMS_SQL.NUMBER_TABLE;
BEGIN
    localtab(1) := 1000;
    runarray ('testdyn', '1, sysdate', localtab);
    DBMS_OUTPUT.PUT_LINE ('Years Eli Has Been Around');
    FOR ind IN localtab.FIRST .. localtab.LAST
    LOOP
       DBMS_OUTPUT.PUT_LINE (localtab(ind));
    END LOOP;
END;
/
