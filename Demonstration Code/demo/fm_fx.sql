BEGIN
   DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'Month Day Year'));
   DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'FMMonth Day Year'));
   DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'Month Day FMYear'));
   DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'Month FXDay FMYear'));
END;