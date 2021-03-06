CREATE TABLE plch_log (created_on DATE)
/

ALTER SESSION SET plsql_ccflags='use_determ:true'
/

CREATE OR REPLACE PACKAGE plch_getdata
IS
   PROCEDURE log_count (title_in IN VARCHAR2);

   FUNCTION n (i NUMBER)
      RETURN NUMBER
      $IF $$use_determ $THEN
   DETERMINISTIC  $END
                ;

   FUNCTION vc (vc VARCHAR2)
      RETURN VARCHAR2
      $IF $$use_determ $THEN
   DETERMINISTIC  $END
                ;

   FUNCTION b (b BOOLEAN)
      RETURN BOOLEAN
      $IF $$use_determ $THEN
   DETERMINISTIC  $END
                ;
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
      INSERT INTO plch_log
           VALUES (SYSDATE);

      COMMIT;
   END;

   FUNCTION n (i NUMBER)
      RETURN NUMBER
      $IF $$use_determ $THEN
   DETERMINISTIC  $END
   IS
   BEGIN
      log_call ();
      RETURN i;
   END;

   FUNCTION vc (vc VARCHAR2)
      RETURN VARCHAR2
      $IF $$use_determ $THEN
   DETERMINISTIC  $END
   IS
   BEGIN
      log_call ();
      RETURN vc;
   END;

   FUNCTION b (b BOOLEAN)
      RETURN BOOLEAN
      $IF $$use_determ $THEN
   DETERMINISTIC  $END
   IS
   BEGIN
      log_call ();
      RETURN b;
   END;
END;
/

CREATE OR REPLACE PROCEDURE plch_tester (title_in IN VARCHAR2)
IS
   n    NUMBER;
   vc   VARCHAR2 (100);
   b    BOOLEAN;
BEGIN
   DBMS_OUTPUT.put_line (title_in);
   plch_getdata.log_count ('N Before literal');

   FOR i IN 1 .. 10
   LOOP
      n := plch_getdata.n (1);
   END LOOP;

   plch_getdata.log_count ('N After literal 10 iterations');

   --
   FOR i IN 1 .. 10
   LOOP
      n := plch_getdata.n (i / (i * 1));
   END LOOP;

   plch_getdata.log_count ('N After expression 10 iterations');

   --
   FOR i IN 1 .. 10
   LOOP
      vc := plch_getdata.vc ('abc');
   END LOOP;

   plch_getdata.log_count ('VC After literal 10 iterations');

   --
   FOR i IN 1 .. 10
   LOOP
      vc := plch_getdata.vc ('abc' || TO_CHAR (1));
   END LOOP;

   plch_getdata.log_count ('VC After expression 10 iterations');

   --
   FOR i IN 1 .. 10
   LOOP
      b := plch_getdata.b (TRUE);
   END LOOP;

   plch_getdata.log_count ('B After literal 10 iterations');

   --
   FOR i IN 1 .. 10
   LOOP
      b := plch_getdata.b (CASE WHEN i < 100 THEN TRUE ELSE FALSE END);
   END LOOP;

   plch_getdata.log_count ('B After expression 10 iterations');
END;
/

BEGIN
   plch_tester ('Deterministic');
END;
/

ALTER SESSION SET plsql_ccflags='use_determ:false'
/

ALTER PACKAGE plch_getdata COMPILE;
/

ALTER PACKAGE plch_getdata COMPILE BODY;
/

BEGIN
   DELETE FROM plch_log;

   plch_tester ('Non-deterministic');
END;
/

DROP TABLE plch_log
/

DROP PACKAGE plch_getdata
/