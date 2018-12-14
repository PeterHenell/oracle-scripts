/*
The formula used by Oracle for MOD is:

   MOD (m, n) = m - n * FLOOR (m/n)

whereas the formula used for REMAINDER  is:

   REMAINDER (m, n) = m - n * ROUND (m/n)
*/
BEGIN
   DBMS_OUTPUT.put_line (MOD (15, 4));
   DBMS_OUTPUT.put_line (REMAINDER (15, 4));
   DBMS_OUTPUT.put_line (MOD (15, 9));
   DBMS_OUTPUT.put_line (MOD (15.55, 9));
   DBMS_OUTPUT.put_line (REMAINDER (15, 9));
   DBMS_OUTPUT.put_line (REMAINDER (15.55, 9));
END;
/