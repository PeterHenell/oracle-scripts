CREATE OR REPLACE PROCEDURE log_error (error_in     IN PLS_INTEGER DEFAULT NULL
                                     , message_in   IN VARCHAR2 := NULL)
IS
BEGIN
   DBMS_OUTPUT.put_line ('Error Logged:');
   DBMS_OUTPUT.put_line ('|  Code     : ' || NVL (error_in, SQLCODE));
   DBMS_OUTPUT.
    put_line (
      '|  Message  : ' || NVL (message_in, DBMS_UTILITY.format_error_stack));
END;
/