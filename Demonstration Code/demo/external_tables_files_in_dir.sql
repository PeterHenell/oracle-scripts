SPOOL external_tables_files_in_dir.log

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

   EXECUTE IMMEDIATE 'grant create any directory to hr';
   
   EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY TEMP AS ''c:\temp''';

   EXECUTE IMMEDIATE 'GRANT READ,WRITE ON DIRECTORY TEMP to hr';

   EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY EXECUTE_DIRECTORY AS ''c:\temp''';

   EXECUTE IMMEDIATE 'GRANT READ ON DIRECTORY EXECUTE_DIRECTORY to hr';
END;
/

CONNECT hr/hr

SET serveroutput on format wrapped

DROP TABLE files_in_temp
/

CREATE TABLE files_in_temp
(
  file_name VARCHAR2(1000)
)
ORGANIZATION external
( 
  TYPE oracle_loader
  DEFAULT DIRECTORY TEMP
  ACCESS PARAMETERS
    ( 
      RECORDS DELIMITED BY NEWLINE
      PREPROCESSOR execute_directory: 'show_files.bat'
      FIELDS TERMINATED BY WHITESPACE
    )
    LOCATION ( 'show_files.bat')
)
REJECT LIMIT UNLIMITED
/

SELECT *
  FROM files_in_temp
 WHERE file_name LIKE 'temp%'
/

SPOOL OFF

/*
Output from running script:

Connected as SYS@ORACLE112 as sysdba
PL/SQL procedure successfully completed.
Connected as HR@ORACLE112
Table dropped.
Table created.

FILE_NAME                                                                       
--------------------------------------------------------------------------------
temp.camrec                                                                     
temp.sql                                                                        
temp.txt                                                                        
temp.xml                                                                        
temp.zip                                                                        
temp1.pkb                                                                       
temp2.pkb                                                                       
temp2.txt                                                                       

8 rows selected.

*/