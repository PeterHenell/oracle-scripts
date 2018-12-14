/* 
   Adding non-deterministic code 
This script demonstrates that in Oracle Database 11g and higher,
   use of the DETERMINISTIC keyword will result in caching of IN and
   RETURN values, leading to optimization that avoids unnecessary
   execution of the function - but only if the IN value is static
   at the time of compilation. If the argument value is an expression,
   then the optimization does not occur.
   
   _Nikotin has also confirmed through analysis of trace files that 
   for the n function below, when called with a compile-time static value, 
   the loop itself is optimized right out of the compiled code.
*/

CREATE TABLE plch_log (created_on DATE)
/

CREATE OR REPLACE PACKAGE plch_getdata
IS
   PROCEDURE log_count (title_in IN VARCHAR2);

   FUNCTION vc (vc VARCHAR2)
      RETURN VARCHAR2
      DETERMINISTIC;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_getdata
IS
   PROCEDURE log_count (title_in IN VARCHAR2)
   IS
      l_count   PLS_INTEGER;
   BEGIN
      SELECT COUNT (*) INTO l_count FROM plch_log;
      DBMS_OUTPUT.put_line (title_in || '=' || l_count);
   END;

   PROCEDURE log_call
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      INSERT INTO plch_log VALUES (SYSDATE);
      COMMIT;
   END;

   FUNCTION vc (vc VARCHAR2)
      RETURN VARCHAR2 DETERMINISTIC
   IS
   BEGIN
      log_call ();
      RETURN vc;
   END;
END;
/

DECLARE
   vc   VARCHAR2 (100);
BEGIN
   FOR i IN 1 .. 10
   LOOP
      vc := plch_getdata.vc ('abc');
   END LOOP;

   plch_getdata.log_count ('VC 10 iterations in loop');

   FOR i IN 1 .. 10
   LOOP
      vc := plch_getdata.vc ('abc');
      vc := 'abc' || TO_CHAR (SYSDATE);
   END LOOP;

   plch_getdata.log_count ('VC 10 iterations with non-deterministic code in loop');
END;
/

/*
VC 10 iterations in loop=1
VC 10 iterations with non-deterministic code in loop=11
*/

DROP TABLE plch_log
/

DROP PACKAGE plch_getdata
/