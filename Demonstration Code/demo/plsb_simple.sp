CREATE OR REPLACE PROCEDURE plsb (str IN VARCHAR2, val IN BOOLEAN)
IS
BEGIN
   IF val
   THEN
      DBMS_OUTPUT.put_line (str || ' - TRUE');
   ELSIF NOT val
   THEN
      DBMS_OUTPUT.put_line (str || ' - FALSE');
   ELSE
      DBMS_OUTPUT.put_line (str || ' - NULL');
   END IF;
END plsb;
/