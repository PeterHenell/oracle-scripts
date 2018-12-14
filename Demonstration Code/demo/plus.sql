CREATE OR REPLACE FUNCTION "+" (a NUMBER, b NUMBER)
   RETURN NUMBER
IS
BEGIN
   RETURN a + b;
END;
/

DECLARE
   n   NUMBER;
BEGIN
   n := "+" (1, 2);
   n := 1 "+" 2;
   dbms_output.put_line ( n );
END;
/