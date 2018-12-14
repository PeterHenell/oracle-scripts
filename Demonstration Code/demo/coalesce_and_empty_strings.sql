DECLARE
   c    CHAR (10) := COALESCE ('', 'abc');
BEGIN
   DBMS_OUTPUT.put_line ('Length='||LENGTH (c));
   DBMS_OUTPUT.put_line (c);
END;
/

DECLARE
   c   CHAR (10) := COALESCE ('', '');
BEGIN
   DBMS_OUTPUT.put_line ('Length='||LENGTH (c));
   DBMS_OUTPUT.put_line (c);
END;
/

DECLARE
   c   CHAR (10) := COALESCE ('', NULL);
BEGIN
   DBMS_OUTPUT.put_line ('Length='||LENGTH (c));
   DBMS_OUTPUT.put_line (c);
END;
/

DECLARE
   c   CHAR (10) := COALESCE (NULL, NULL);
BEGIN
   DBMS_OUTPUT.put_line ('Length='||LENGTH (c));
   DBMS_OUTPUT.put_line (c);
END;
/