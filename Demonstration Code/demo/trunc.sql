BEGIN
   DBMS_OUTPUT.put_line (TRUNC (10.23, 1));
   DBMS_OUTPUT.put_line (TRUNC (10.25, 1));
   DBMS_OUTPUT.put_line (TRUNC (10.27, 1));
   DBMS_OUTPUT.put_line (TRUNC (123.456, -1));
   DBMS_OUTPUT.put_line (TRUNC (123.456, -2));
END;