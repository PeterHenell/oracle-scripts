DECLARE
   p1   PLS_INTEGER := 2147483647;
   p2   PLS_INTEGER := 1;
   n    NUMBER;
BEGIN
   n := p1 + p2;
   DBMS_OUTPUT.put_line (n);
END;
/

DECLARE
   p1   SIMPLE_INTEGER := 2147483647;
   p2   SIMPLE_INTEGER := 1;
   n    NUMBER;
BEGIN
   n := p1 + p2;
   DBMS_OUTPUT.put_line (n);
END;
/

DECLARE
   p1   PLS_INTEGER := 2147483647;
   p2   NUMBER := 1;
   n    NUMBER;
BEGIN
   n := - p1 + p2;
   DBMS_OUTPUT.put_line (n);
END;
/
