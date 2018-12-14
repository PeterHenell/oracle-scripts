/* Show how serially reusable packages don't preserve global state
   and reinitialize each time.
*/

CREATE OR REPLACE PACKAGE demo
AS
   PRAGMA SERIALLY_REUSABLE;
   global_x   PLS_INTEGER := 10;

   CURSOR emps_cur
   IS
      SELECT * FROM employees;
END;
/

BEGIN
   demo.global_x := 50;
   DBMS_OUTPUT.put_line (demo.global_x);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (demo.global_x);
END;
/

CREATE OR REPLACE PACKAGE serialized
IS
   PRAGMA SERIALLY_REUSABLE;

   FUNCTION get
      RETURN VARCHAR2;
END serialized;
/

CREATE OR REPLACE PACKAGE BODY serialized
IS
   PRAGMA SERIALLY_REUSABLE;
   v   VARCHAR2 (3) := 'ABC';

   FUNCTION get
      RETURN VARCHAR2
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('getting v');
      RETURN v;
   END;
BEGIN
   DBMS_OUTPUT.put_line ('Before I show you v...');
END serialized;
/

/* Package re-initializes each time */

BEGIN
   DBMS_OUTPUT.put_line (serialized.get);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (serialized.get);
END;
/