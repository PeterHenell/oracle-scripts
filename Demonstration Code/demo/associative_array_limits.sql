BEGIN
   DBMS_OUTPUT.put_line (-2 ** 31 + 1);
   DBMS_OUTPUT.put_line (2 ** 31 - 1);
   DBMS_OUTPUT.put_line (-1 * (-2 ** 31 + 1) + (2 ** 31 - 1));
END;