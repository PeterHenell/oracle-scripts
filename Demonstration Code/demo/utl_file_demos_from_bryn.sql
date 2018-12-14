CONNECT Sys/p@111 AS SYSDBA

DECLARE
   PROCEDURE create_user (who IN VARCHAR2)
   IS
      user_does_not_exist exception;
      PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || who || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      EXECUTE IMMEDIATE   '
      grant Create Session, Resource to '
                       || who
                       || ' identified by p';
   END create_user;
BEGIN
   create_user ('Usr');
END;
/

DECLARE
   PROCEDURE create_directory (o_dir IN VARCHAR2, f_dir IN VARCHAR2)
   IS
      directory_does_not_exist exception;
      PRAGMA EXCEPTION_INIT (directory_does_not_exist, -04043);
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop directory ' || o_dir;
      EXCEPTION
         WHEN directory_does_not_exist
         THEN
            NULL;
      END;

      EXECUTE IMMEDIATE   '
      create directory '
                       || o_dir
                       || ' as '''
                       || f_dir
                       || '''';
   END create_directory;
BEGIN
   create_directory ('My_Dir', '/home/bllewell/t');
--Create_Directory('My_Dir', 'C:\Temp');
END;
/

GRANT WRITE, READ ON DIRECTORY my_dir TO usr
/


CONNECT Usr/p@111
-- Don't want to be distracted by Inlining warnings
ALTER SESSION SET plsql_optimize_level = 2
/

CREATE PROCEDURE p1
IS
   f1   UTL_FILE.file_type;
   f2   UTL_FILE.file_type;


   PROCEDURE show_lines (f IN UTL_FILE.file_type)
   IS
      buff   VARCHAR2 (32767);
   BEGIN
      DBMS_OUTPUT.put_line ('');

      LOOP
         UTL_FILE.get_line (f, buff);
         DBMS_OUTPUT.put_line (buff);
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END show_lines;
BEGIN
   f1 :=
      UTL_FILE.fopen (location       => 'MY_DIR'
                    , filename       => 't.txt'
                    , open_mode      => 'r'
                    , max_linesize   => 32767
                     );
   f2 :=
      UTL_FILE.fopen (location       => 'MY_DIR'
                    , filename       => 't.txt'
                    , open_mode      => 'r'
                    , max_linesize   => 32767
                     );


   show_lines (f1);
   show_lines (f2);


   UTL_FILE.fclose (f1);
   UTL_FILE.fclose (f2);
END p1;
/

BEGIN
   p1 ();
END;
/


CREATE PROCEDURE p2
IS
   f1   UTL_FILE.file_type;
   f2   UTL_FILE.file_type;


   PROCEDURE show_lines (f IN UTL_FILE.file_type)
   IS
      buff   VARCHAR2 (32767);
   BEGIN
      DBMS_OUTPUT.put_line ('');

      LOOP
         UTL_FILE.get_line (f, buff);
         DBMS_OUTPUT.put_line (buff);
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END show_lines;
BEGIN
   f1 :=
      UTL_FILE.fopen (location       => 'MY_DIR'
                    , filename       => 't.txt'
                    , open_mode      => 'r'
                    , max_linesize   => 32767
                     );
   f2 :=
      UTL_FILE.fopen (location       => 'MY_DIR'
                    , filename       => 't.txt'
                    , open_mode      => 'w'
                    , max_linesize   => 32767
                     );


   show_lines (f1);
   show_lines (f2);


   UTL_FILE.fclose (f1);
   UTL_FILE.fclose (f2);
END p2;
/

--LIST
--SHOW ERRORS

BEGIN
   p2 ();
END;
/


CREATE PROCEDURE p3
IS
   f2   UTL_FILE.file_type;


   PROCEDURE show_lines (f IN UTL_FILE.file_type)
   IS
      buff   VARCHAR2 (32767);
   BEGIN
      DBMS_OUTPUT.put_line ('');

      LOOP
         UTL_FILE.get_line (f, buff);
         DBMS_OUTPUT.put_line (buff);
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END show_lines;
BEGIN
   f2 :=
      UTL_FILE.fopen (location       => 'MY_DIR'
                    , filename       => 't.txt'
                    , open_mode      => 'w'
                    , max_linesize   => 32767
                     );


   show_lines (f2);


   UTL_FILE.fclose (f2);
END p3;
/

--LIST
--SHOW ERRORS

BEGIN
   p3 ();
END;
/


CREATE PROCEDURE p4
IS
   f1   UTL_FILE.file_type;
   f2   UTL_FILE.file_type;
BEGIN
   f1 :=
      UTL_FILE.fopen (location       => 'MY_DIR'
                    , filename       => 't.txt'
                    , open_mode      => 'w'
                    , max_linesize   => 32767
                     );
   f2 :=
      UTL_FILE.fopen (location       => 'MY_DIR'
                    , filename       => 't.txt'
                    , open_mode      => 'w'
                    , max_linesize   => 32767
                     );


   UTL_FILE.put_line (f1, 'via f1');
   UTL_FILE.put_line (f2, 'via f2');


   UTL_FILE.fclose (f1);
   UTL_FILE.fclose (f2);
END p4;
/

LIST
SHOW ERRORS

BEGIN
   p4 ();
END;
/


CREATE OR REPLACE PROCEDURE p5
IS
BEGIN
   DECLARE
      f1   UTL_FILE.file_type;
   BEGIN
      f1 :=
         UTL_FILE.fopen (location       => 'MY_DIR'
                       , filename       => 't.txt'
                       , open_mode      => 'w'
                       , max_linesize   => 32767
                        );


      FOR j IN 1 .. 5
      LOOP
         UTL_FILE.put_line (f1, 'Test ' || j);
      END LOOP;
   --Utl_File.Fflush(f1);
   --Utl_File.Fclose(f1);
   END;


   DECLARE
      f2   UTL_FILE.file_type;


      PROCEDURE show_lines (f IN UTL_FILE.file_type)
      IS
         buff   VARCHAR2 (32767);
      BEGIN
         DBMS_OUTPUT.put_line ('');

         LOOP
            UTL_FILE.get_line (f, buff);
            DBMS_OUTPUT.put_line (buff);
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END show_lines;
   BEGIN
      f2 :=
         UTL_FILE.fopen (location       => 'MY_DIR'
                       , filename       => 't.txt'
                       , open_mode      => 'r'
                       , max_linesize   => 32767
                        );


      show_lines (f2);
      UTL_FILE.fclose (f2);
   END;
END p5;
/

BEGIN
   p5 ();
END;
/