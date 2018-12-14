CONNECT Sys/p AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
BEGIN
   BEGIN
      EXECUTE IMMEDIATE 'drop user Usr cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE '
    grant Create Session, Resource to Usr identified by p';

   EXECUTE IMMEDIATE '
    grant Select on sys.v_$sesstat to Usr';

   EXECUTE IMMEDIATE '
    grant Select on sys.v_$statname to Usr';
END;
/

CONNECT Usr/p