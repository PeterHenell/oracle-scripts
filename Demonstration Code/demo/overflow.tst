BEGIN
   p.l ('Limits are: ' || 
     TO_CHAR (-1 * POWER (2, 31) + 1) || ' to ' || 
     TO_CHAR (POWER (2, 31)-1));
END;
/

DECLARE
   test BINARY_INTEGER := 2147483647;
   test1 BINARY_INTEGER := 2147483647;
BEGIN
   test := test + test1;
END;
/
DECLARE
   test PLS_INTEGER := 2147483647;
   test1 PLS_INTEGER := 2147483647;
BEGIN
   test := test + test1;
END;
/
DECLARE
   test BINARY_INTEGER := -2147483647;
   test1 BINARY_INTEGER := -2147483647;
BEGIN
   test := test + test1;
END;
/
DECLARE
   test PLS_INTEGER := -2147483647;
   test1 PLS_INTEGER := -2147483647;
BEGIN
   test := test + test1;
END;
/
