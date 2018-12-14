/* 
What happens when you have more than one
user-defined exception pointing back to 
the same error code?
*/

CREATE OR REPLACE PACKAGE plch_pkg
AS
   my_exception   EXCEPTION;
   PRAGMA EXCEPTION_INIT (my_exception, -1);
END plch_pkg;
/

/* Three different handlers */

CREATE OR REPLACE PROCEDURE plch_dupexc (
   desc_in IN VARCHAR2)
IS
   my_exception   EXCEPTION;
   PRAGMA EXCEPTION_INIT (my_exception, -1);
BEGIN
   DBMS_OUTPUT.put_line (desc_in);
   RAISE my_exception;
EXCEPTION
   WHEN my_exception
   THEN
      DBMS_OUTPUT.put_line ('My exception handled!');
   WHEN DUP_VAL_ON_INDEX
   THEN
      DBMS_OUTPUT.put_line ('My exception handled!');
END;
/

BEGIN
   plch_dupexc ('Three handlers');
END;
/

/* One handler with ORs */

CREATE OR REPLACE PROCEDURE plch_dupexc (
   desc_in IN VARCHAR2)
IS
   my_exception   EXCEPTION;
   PRAGMA EXCEPTION_INIT (my_exception, -1);
BEGIN
   DBMS_OUTPUT.put_line (desc_in);
   RAISE my_exception;
EXCEPTION
   WHEN my_exception OR plch_pkg.my_exception OR DUP_VAL_ON_INDEX
   THEN
      DBMS_OUTPUT.put_line ('My exception handled!');
END;
/

BEGIN
   plch_dupexc ('One handler with ORs');
END;
/

/* Just handle one of the packaged exceptions */

CREATE OR REPLACE PROCEDURE plch_dupexc (
   desc_in IN VARCHAR2)
IS
   my_exception   EXCEPTION;
   PRAGMA EXCEPTION_INIT (my_exception, -1);
BEGIN
   DBMS_OUTPUT.put_line (desc_in);
   RAISE my_exception;
EXCEPTION
   WHEN plch_pkg.my_exception
   THEN
      DBMS_OUTPUT.put_line ('My exception handled!');
END;
/

BEGIN
   plch_dupexc ('One handler for packaged exception');
END;
/

/* Just handle the local exception */

CREATE OR REPLACE PROCEDURE plch_dupexc (
   desc_in IN VARCHAR2)
IS
   my_exception   EXCEPTION;
   PRAGMA EXCEPTION_INIT (my_exception, -1);
BEGIN
   DBMS_OUTPUT.put_line (desc_in);
   RAISE my_exception;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX
   THEN
      DBMS_OUTPUT.put_line ('My exception handled!');
END;
/

BEGIN
   plch_dupexc ('One handler for local exception');
END;
/

/* Clean up */

DROP PACKAGE plch_pkg
/

DROP PROCEDURE plch_dupexc
/