SPOOL demo.log

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
   create_user ('Usr');

   EXECUTE IMMEDIATE 'grant create database directory to Usr';
END;
/

CONNECT Usr/Usr

SET serveroutput on format wrapped

/* Timing utillity */
CREATE OR REPLACE PACKAGE sf_timer
IS
   PROCEDURE start_timer;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL);
END sf_timer;
/

CREATE OR REPLACE PACKAGE BODY sf_timer
IS
   last_timing   NUMBER := NULL;

   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
   END;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line('"' || message_in || '" completed in: '
                           || ROUND (
                                 MOD (
                                      DBMS_UTILITY.get_cpu_time
                                    - last_timing
                                    + POWER (2, 32)
                                  , POWER (2, 32)
                                 )
                                 / 100
                               , 2
                              ));
   END;
END sf_timer;
/

CREATE OR REPLACE DIRECTORY temp AS 'c:\temp'
/

DECLARE
   l_file   UTL_FILE.file_type;
BEGIN
   l_file := UTL_FILE.fopen ('TEMP', 'departments100000.ctl', 'W');

   FOR indx IN 1 .. 100000
   LOOP
      UTL_FILE.put_line (
         l_file
       ,    TO_CHAR (indx)
         || ','
         || 'Department'
         || TO_CHAR (indx)
         || ','
         || 'City'
         || TO_CHAR (indx)
      );
   END LOOP;

   UTL_FILE.fclose (l_file);
END;
/

DROP TABLE departments_ext
/

CREATE TABLE departments_ext (
   department_id        NUMBER(6),
   department_name      VARCHAR2(20),
   department_location  VARCHAR2(25) 
)
ORGANIZATION EXTERNAL
(TYPE oracle_loader
 DEFAULT DIRECTORY TEMP
 ACCESS PARAMETERS
 (
  RECORDS DELIMITED BY newline
  BADFILE 'departments.bad'
  DISCARDFILE 'departments.dis'
  LOGFILE 'departments.log'
  FIELDS TERMINATED BY ","  OPTIONALLY ENCLOSED BY '"'
  (
   department_id        INTEGER EXTERNAL(6),
   department_name      CHAR(20),
   department_location  CHAR(25)
  )
 )
 LOCATION ('departments100000.ctl')
)
REJECT LIMIT UNLIMITED
/

DECLARE
   l_file    UTL_FILE.file_type;
   l_lines   DBMS_SQL.varchar2a;
BEGIN
   sf_timer.start_timer;
   l_file := UTL_FILE.fopen ('TEMP', 'departments100000.ctl', 'R');

   LOOP
      UTL_FILE.get_line (l_file, l_lines (l_lines.COUNT + 1));
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      UTL_FILE.fclose (l_file);
      sf_timer.show_elapsed_time ('Read 100000 lines with UTL_FILE');
END;
/

DECLARE
   l_lines   DBMS_SQL.varchar2a;
BEGIN
   sf_timer.start_timer;
   FOR rec IN (SELECT *
                 FROM departments_ext)
   LOOP
      l_lines (l_lines.COUNT + 1) :=
            TO_CHAR (rec.department_id)
         || ','
         || rec.department_name
         || ','
         || rec.department_location;
   END LOOP;
   sf_timer.show_elapsed_time ('Read 100000 lines with External Table');
END;
/

CONNECT Sys/quest AS SYSDBA
DROP USER Usr CASCADE
/

SPOOL OFF

/*
Read 100000 lines with UTL_FILE - Elapsed CPU : 1.33 seconds.
Read 100000 lines with External Table - Elapsed CPU : .33 seconds.
*/
