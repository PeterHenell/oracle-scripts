/*
Written by Bryn Llewellyn
*/

CONNECT Sys/p@Main AS SYSDBA

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
    grant Create Session, Resource
      to Usr identified by p';
END;
/