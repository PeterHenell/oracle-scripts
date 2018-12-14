DECLARE
   /* And cannot be NULL */
   i   SIMPLE_INTEGER := 2 ** 31 - 1;
--i   PLS_INTEGER := 2 ** 31 - 1;
BEGIN
   i := i + 1;
   DBMS_OUTPUT.put_line (i);
END;