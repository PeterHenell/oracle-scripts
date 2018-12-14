CREATE OR REPLACE PROCEDURE read_out (n OUT NUMBER)
IS
BEGIN
   DBMS_OUTPUT.put_line ('n initial=' || n);
   n := 1;
   DBMS_OUTPUT.put_line ('n after assignment=' || n);
   RAISE VALUE_ERROR;
END;
/

DECLARE
   n   NUMBER;
BEGIN
   read_out (n);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('after error=' || n);
END;
/