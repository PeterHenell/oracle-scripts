DECLARE
   bills_turf VARCHAR2(2000);
BEGIN
   bills_turf := http_www ('microsoft');
EXCEPTION
   WHEN UTL_HTTP.REQUEST_FAILED
   THEN
      DBMS_OUTPUT.PUT_LINE (
         'HTTP Request Failed!');
   WHEN UTL_HTTP.INIT_FAILED
   THEN
      DBMS_OUTPUT.PUT_LINE (
         'HTTP initialization failed!');
END;
/
