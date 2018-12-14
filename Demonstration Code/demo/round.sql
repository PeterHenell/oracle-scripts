BEGIN
   DBMS_OUTPUT.put_line (ROUND (10.25));
   DBMS_OUTPUT.put_line (ROUND (10.25, 1));
   DBMS_OUTPUT.put_line (ROUND (10.23, 1));
   DBMS_OUTPUT.put_line (ROUND (10.25, 2));
   DBMS_OUTPUT.put_line (ROUND (10.25, -2));
   DBMS_OUTPUT.put_line (ROUND (125, -2));
END;