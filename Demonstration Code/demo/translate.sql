BEGIN
   DBMS_OUTPUT.put_line (TRANSLATE ('Steven Feuerstein', '#e', '#'));
   DBMS_OUTPUT.put_line (TRANSLATE ('Steven Feuerstein', 'ses', 's'));
   DBMS_OUTPUT.put_line (TRANSLATE ('Steven Feuerstein', 'ee', 'e'));
END;
/
