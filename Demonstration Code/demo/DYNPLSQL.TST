CREATE OR REPLACE PROCEDURE test_dynplsql (counter IN INTEGER)
IS
   n NUMBER;
   c PLS_INTEGER; 
   fdbk PLS_INTEGER;
BEGIN
   n := DBMS_UTILITY.GET_TIME;
   FOR i IN 1 .. counter
   LOOP
      PLV.plsql_identifier := 'abc';
   END LOOP;
   DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.GET_TIME - n);

   n := DBMS_UTILITY.GET_TIME;
   c := DBMS_SQL.OPEN_CURSOR;  /*Toronto*/
   FOR i IN 1 .. counter
   LOOP
      DBMS_SQL.PARSE (c, 'BEGIN PLV.plsql_identifier := ''abc''; END;', DBMS_SQL.NATIVE);
      fdbk := DBMS_SQL.EXECUTE (c);
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR (c);
   DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.GET_TIME - n);
END;
/
   
