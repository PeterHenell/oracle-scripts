CREATE OR REPLACE PROCEDURE plch_proc
IS
BEGIN
   DBMS_OUTPUT.put_line ($$plsql_unit);
   DBMS_OUTPUT.put_line (DBMS_UTILITY.format_call_stack);
END;
/

BEGIN
   plch_proc ();
END;
/

CREATE OR REPLACE PACKAGE plch_pkg
IS
   PROCEDURE plch_proc;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   PROCEDURE plch_proc
   IS
   BEGIN
      DBMS_OUTPUT.put_line ($$plsql_unit);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_call_stack);
   END;
END;
/

BEGIN
   plch_pkg.plch_proc ();
END;
/

CREATE OR REPLACE PROCEDURE plch_proc2
IS
   PROCEDURE plch_proc
   IS
   BEGIN
      DBMS_OUTPUT.put_line ($$plsql_unit);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_call_stack);
   END;
BEGIN
   plch_proc;
END;
/

BEGIN
   plch_proc2 ();
END;
/

CREATE OR REPLACE TYPE plch_ot IS OBJECT
(
   n NUMBER,
   STATIC PROCEDURE plch_proc
)
/

CREATE OR REPLACE TYPE BODY plch_ot
IS
   STATIC PROCEDURE plch_proc
   IS
   BEGIN
      DBMS_OUTPUT.put_line ($$plsql_unit);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_call_stack);
   END;
END;
/

BEGIN
   plch_ot.plch_proc ();
END;
/

CREATE OR REPLACE PROCEDURE plch_proc3
IS
BEGIN
   EXECUTE IMMEDIATE 'begin plch_proc; end;';
END;
/

BEGIN
   plch_proc3;
END;
/


/* Clean up */

DROP PROCEDURE plch_proc
/

DROP PROCEDURE plch_proc2
/

DROP PROCEDURE plch_proc3
/

DROP PACKAGE plch_pkg
/

DROP TYPE plch_ot
/