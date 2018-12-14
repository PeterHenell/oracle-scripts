DECLARE
   l_strings   DBMS_SQL.varchar2s;
BEGIN
   l_strings (NULL) := 1;
   DBMS_OUTPUT.put_line (l_strings (NULL));
END;
/

DECLARE
   l_strings   DBMS_SQL.varchar2s;
BEGIN
   l_strings (NULL) := 2;
   l_strings ('') := 2;
   DBMS_OUTPUT.put_line (l_strings (NULL));
END;
/

