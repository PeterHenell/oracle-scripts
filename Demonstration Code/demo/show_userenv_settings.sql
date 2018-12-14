/* Show some USERENV settings */

DECLARE
   PROCEDURE show_setting (NAME_IN IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            NAME_IN || ' = ' || SYS_CONTEXT ('USERENV', NAME_IN)
      );
   END;
BEGIN
   show_setting ('SESSION_USER');
   show_setting ('CURRENT_USER');
   show_setting ('PROXY_USER');
   show_setting ('AUTHENTICATED_IDENTITY');
   DBMS_SESSION.set_identifier ('Sam');
   show_setting ('CLIENT_IDENTIFIER');
END;
/
