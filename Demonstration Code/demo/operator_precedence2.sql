BEGIN
   DBMS_OUTPUT.put_line (3 * 2 ** 2 - 5);
END;
/

BEGIN
   DBMS_OUTPUT.put_line ( (3 * 2) ** 2 - 5);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (3 * 2 ** (2 - 5));
END;
/

BEGIN
   DBMS_OUTPUT.put_line ( (3 * (2 ** 2)) - 5);
END;
/