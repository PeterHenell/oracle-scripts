/* Formatted on 2002/08/13 15:06 (Formatter Plus v4.7.0) */

DECLARE
   PROCEDURE showenv (str IN VARCHAR2, len IN PLS_INTEGER := NULL)
   IS
   BEGIN
      IF len IS NULL
      THEN
         DBMS_OUTPUT.put_line (str || '=' || SYS_CONTEXT ('USERENV', str));
      ELSE
         DBMS_OUTPUT.put_line (
            str || ' changed to =' || SYS_CONTEXT ('USERENV', str, len)
         );
      END IF;
   END;
BEGIN
   showenv ('NLS_CURRENCY');
   showenv ('NLS_CALENDAR');
   showenv ('NLS_DATE_FORMAT');
   showenv ('NLS_DATE_LANGUAGE');
   showenv ('AUTHENTICATION_DATA');
   showenv ('SESSION_USER');
   showenv ('CURRENT_USER');
   showenv ('CURRENT_SCHEMA');
   showenv ('CURRENT_SCHEMAID');
   showenv ('SESSION_USERID');
   showenv ('CURRENT_USERID');
   showenv ('PROXY_USER');
   showenv ('IP_ADDRESS');
END;
/
