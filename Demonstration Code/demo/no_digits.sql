CREATE OR REPLACE FUNCTION no_digits (string_in IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN TRANSLATE (string_in, 'A1234567890', 'A');
END;
/

BEGIN
   DBMS_OUTPUT.put_line ('No digits = "' || no_digits ('123') || '"');
   DBMS_OUTPUT.put_line ('No digits = "' || no_digits ('123abc') || '"');
   DBMS_OUTPUT.put_line ('No digits = "' || no_digits ('abc123') || '"');
   DBMS_OUTPUT.put_line ('No digits = "' || no_digits ('a1b2c3') || '"');
   DBMS_OUTPUT.put_line ('No digits = "' || no_digits ('abc') || '"');
END;
/