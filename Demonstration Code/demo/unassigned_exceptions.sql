DECLARE
   e1   EXCEPTION;
   e2   EXCEPTION;
   PRAGMA EXCEPTION_INIT (e1, -20001);
   PRAGMA EXCEPTION_INIT (e2, -20001);
BEGIN
   RAISE e2;
EXCEPTION
   WHEN e1
   THEN
      DBMS_OUTPUT.put_line ('e1 caught');
   WHEN e2
   THEN
      DBMS_OUTPUT.put_line ('e2 caught');
END;
/

DECLARE
   e1   EXCEPTION;
   e2   EXCEPTION;
BEGIN
   RAISE e2;
EXCEPTION
   WHEN e1
   THEN
      DBMS_OUTPUT.put_line ('e1 caught');
   WHEN e2
   THEN
      DBMS_OUTPUT.put_line ('e2 caught');
END;
/


DECLARE
   e1   EXCEPTION;
   e2   EXCEPTION;
   PRAGMA EXCEPTION_INIT (e1, -20001);
   PRAGMA EXCEPTION_INIT (e2, -20002);
BEGIN
   RAISE e2;
EXCEPTION
   WHEN e1
   THEN
      DBMS_OUTPUT.put_line ('e1 caught');
   WHEN e2
   THEN
      DBMS_OUTPUT.put_line ('e2 caught');
END;
/

/* Different in a package? */

CREATE OR REPLACE PACKAGE plch_pkg
IS
   e1   EXCEPTION;
   e2   EXCEPTION;
END;
/

BEGIN
   RAISE plch_pkg.e2;
EXCEPTION
   WHEN plch_pkg.e1
   THEN
      DBMS_OUTPUT.put_line ('e1 caught');
   WHEN plch_pkg.e2
   THEN
      DBMS_OUTPUT.put_line ('e2 caught');
END;
/

/* Conflict with exceptions in a package? */

CREATE OR REPLACE PACKAGE plch_pkg
IS
   e1   EXCEPTION;
   e2   EXCEPTION;
END;
/

DECLARE
   e1   EXCEPTION;
   e2   EXCEPTION;
BEGIN
   RAISE plch_pkg.e2;
EXCEPTION
   WHEN e2
   THEN
      DBMS_OUTPUT.put_line ('local e2 caught');
   WHEN plch_pkg.e2
   THEN
      DBMS_OUTPUT.put_line ('e2 caught');
END;
/

/* Clean up */

DROP PACKAGE plch_pkg
/