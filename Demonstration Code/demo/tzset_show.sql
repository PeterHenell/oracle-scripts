/* Formatted on 2002/01/28 11:34 (Formatter Plus v4.6.0) */
CREATE OR REPLACE PROCEDURE tz_set_and_show (tz_in IN VARCHAR2 := null)
IS
BEGIN
   IF tz_in IS NOT NULL
   THEN
      EXECUTE IMMEDIATE    'alter session set time_zone = '''
                        || tz_in
                        || '''';
   END IF;

   DBMS_OUTPUT.put_line (   'SESSIONTIMEZONE = '
                         || SESSIONTIMEZONE);
   DBMS_OUTPUT.put_line (   'CURRENT_TIMESTAMP = '
                         || CURRENT_TIMESTAMP);
   DBMS_OUTPUT.put_line (   'LOCALTIMESTAMP = '
                         || LOCALTIMESTAMP);
   DBMS_OUTPUT.put_line (
         'SYS_EXTRACT_UTC (LOCALTIMESTAMP) = '
      || sqlexpr ('SYS_EXTRACT_UTC (LOCALTIMESTAMP)')
   );
END;
/

