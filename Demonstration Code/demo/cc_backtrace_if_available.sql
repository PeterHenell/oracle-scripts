CREATE OR REPLACE FUNCTION error_backtrace
   RETURN VARCHAR2
IS
   l_backtrace VARCHAR2 ( 32767 );
BEGIN
   EXECUTE IMMEDIATE 'BEGIN :val := DBMS_UTILITY.format_error_backtrace; END;'
               USING OUT l_backtrace;

   RETURN l_backtrace;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN NULL;
END error_backtrace;
/
