set serveroutput on

DECLARE
   l_offset   VARCHAR2 (100);
BEGIN
   FOR rec IN (SELECT * FROM v$timezone_names)
   LOOP
      BEGIN
         l_offset := TZ_OFFSET (rec.tzname);
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (
               'Unable to show offset for name "' || rec.tzname || '"');
      END;

      BEGIN
         l_offset := TZ_OFFSET (rec.tzabbrev);
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (
                  'Unable to show offset for abbreviation "'
               || rec.tzabbrev
               || '"');
      END;
   END LOOP;
END;
/