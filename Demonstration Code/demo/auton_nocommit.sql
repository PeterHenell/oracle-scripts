CREATE OR REPLACE FUNCTION nothing
   RETURN INTEGER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   UPDATE employees
      SET last_name = 'abc';

   RETURN 1;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (nothing);
END;
/