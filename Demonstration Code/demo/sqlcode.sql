DROP TABLE log_error_table
/

CREATE TABLE log_error_table (errcode INTEGER)
/

BEGIN
   INSERT INTO log_error_table
        VALUES (SQLCODE);
END;
/

DECLARE
   l_code   INTEGER := SQLCODE;
BEGIN
   INSERT INTO log_error_table
        VALUES (l_code);

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/