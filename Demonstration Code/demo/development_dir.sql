CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist exception;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE create_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      /* Grant required privileges...*/
      EXECUTE IMMEDIATE   'grant Create Session, Resource to '
                       || user_in
                       || ' identified by '
                       || user_in;

      DBMS_OUTPUT.put_line ('User "' || user_in || '" was created.');
   END create_user;
BEGIN
   create_user ('test_utl_file');

   EXECUTE IMMEDIATE 'grant create any directory Usr';
END;
/

CONNECT Usr/p

SET serveroutput on format wrapped

SPOOL utl_file.log

DECLARE
   l_file   UTL_FILE.file_type;
BEGIN
   EXECUTE IMMEDIATE 'create or replace directory TEMP AS ''C:\temp''';

   l_file :=
      UTL_FILE.fopen (location    => 'TEMP'
                    , filename    => 'text.txt'
                    , open_mode   => 'W'
                     );
   UTL_FILE.put_line (l_file, 'abc');
END;
/

DECLARE
   l_file    UTL_FILE.file_type;
   l_file1   UTL_FILE.file_type;
   l_line    VARCHAR2 (10000);
BEGIN
   l_file :=
      UTL_FILE.fopen (location    => 'TEMP'
                    , filename    => 'text.txt'
                    , open_mode   => 'R'
                     );

   UTL_FILE.get_line (l_file, l_line);
   DBMS_OUTPUT.put_line (l_line);

   l_file1 :=
      UTL_FILE.fopen (location    => 'TEMP'
                    , filename    => 'text.txt'
                    , open_mode   => 'W'
                     );

   UTL_FILE.put_line (l_file, 'def');
END;
/

SPOOL OFF