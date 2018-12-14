CREATE OR REPLACE FUNCTION plch_func
   RETURN NUMBER
IS
BEGIN
   DBMS_OUTPUT.put_line ('Function called');

   RETURN 10;
END;
/

DECLARE
   n   NUMBER;
BEGIN
   n := NVL (n, plch_func);
   n := NVL (n, plch_func);
END;
/

DECLARE
   n   NUMBER;
BEGIN
   n := CASE WHEN n IS NULL THEN plch_func ELSE n END;
   n := CASE WHEN n IS NULL THEN plch_func ELSE n END;
END;
/