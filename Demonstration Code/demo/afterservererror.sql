CREATE OR REPLACE TRIGGER after_servererror_on_database
   AFTER SERVERERROR ON DATABASE
BEGIN
   DBMS_OUTPUT.put_line ( 'ora_server_error: ' || ora_server_error ( 1 ));
END after_servererror_on_database;
/

SELECT TO_NUMBER ( 'x' ) n
  FROM DUAL
/

DECLARE
   n NUMBER;
BEGIN
   n := TO_NUMBER ( 'x' );
END;
/
