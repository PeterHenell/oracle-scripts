DECLARE
   c   VARCHAR2 (3) := COALESCE ('', 'abc');
BEGIN
   DBMS_OUTPUT.put_line ('Coalesced to "' || c || '"');
END;
/

DECLARE
   c   VARCHAR2 (3) := COALESCE ('abc', '');
BEGIN
   DBMS_OUTPUT.put_line ('Coalesced to "' || c || '"');
END;
/

DECLARE
   c   VARCHAR2 (3) := COALESCE (NULL, 'abc');
BEGIN
   DBMS_OUTPUT.put_line ('Coalesced to "' || c || '"');
END;
/

DECLARE
   c   VARCHAR2 (3) := COALESCE (NULL, '', 'abc');
BEGIN
   DBMS_OUTPUT.put_line ('Coalesced to "' || c || '"');
END;
/