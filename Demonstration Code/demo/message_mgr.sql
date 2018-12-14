DROP TABLE message_mgr_table
/

CREATE TABLE message_mgr_table
(
   msgcode       INTEGER
 , msgtype       VARCHAR2 (30)
 , msgtext       VARCHAR2 (2000)
 , msgname       VARCHAR2 (30)
)
/

CREATE OR REPLACE PACKAGE message_mgr
IS
   c_exception_type   CONSTANT VARCHAR2 (100) := 'EXCEPTION';
   c_warning_type     CONSTANT VARCHAR2 (100) := 'WARNING';


   FUNCTION text (code_in     IN PLS_INTEGER
                , type_in     IN VARCHAR2
                , use_sqlerrm IN BOOLEAN:= TRUE
                 )
      RETURN VARCHAR2;

   FUNCTION name (code_in IN PLS_INTEGER, type_in IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE raise_error (code_in IN PLS_INTEGER);

   PROCEDURE genpkg (NAME_IN    IN VARCHAR2
                   , to_file_in IN BOOLEAN DEFAULT TRUE
                   , dir_in     IN VARCHAR2 DEFAULT NULL
                   , ext_in     IN VARCHAR2 DEFAULT 'pkg'
                    );
END message_mgr;
/

CREATE OR REPLACE PACKAGE BODY message_mgr
IS
   FUNCTION msg_row (code_in IN PLS_INTEGER, type_in IN VARCHAR2)
      RETURN message_mgr_table%ROWTYPE
   IS
      msg_rec   message_mgr_table%ROWTYPE;
   BEGIN
      SELECT *
        INTO msg_rec
        FROM message_mgr_table
       WHERE msgtype = type_in AND msgcode = code_in;

      RETURN msg_rec;
   END;

   FUNCTION text (code_in     IN PLS_INTEGER
                , type_in     IN VARCHAR2
                , use_sqlerrm IN BOOLEAN:= TRUE
                 )
      RETURN VARCHAR2
   IS
      msg_rec   message_mgr_table%ROWTYPE := msg_row (code_in, type_in);
   BEGIN
      IF msg_rec.msgtext IS NULL AND use_sqlerrm
      THEN
         msg_rec.msgtext := SQLERRM (code_in);
      END IF;

      RETURN msg_rec.msgtext;
   END;

   FUNCTION name (code_in IN PLS_INTEGER, type_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
      msg_rec   message_mgr_table%ROWTYPE := msg_row (code_in, type_in);
   BEGIN
      RETURN msg_rec.msgname;
   END;

   PROCEDURE raise_error (code_in IN PLS_INTEGER)
   IS
      l_error   message_mgr_table%ROWTYPE;
   BEGIN
      l_error := msg_row (code_in, c_exception_type);
      raise_application_error (l_error.msgcode, l_error.msgtext);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE PROGRAM_ERROR;
   END raise_error;


   PROCEDURE genpkg (NAME_IN    IN VARCHAR2
                   , to_file_in IN BOOLEAN DEFAULT TRUE
                   , dir_in     IN VARCHAR2 DEFAULT NULL
                   , ext_in     IN VARCHAR2 DEFAULT 'pkg'
                    )
   IS
      CURSOR exc_20000
      IS
         SELECT *
           FROM message_mgr_table
          WHERE msgcode BETWEEN -20999 AND -20000 AND msgtype = 'EXCEPTION';

      -- Send output to file or screen?
      l_to_screen   BOOLEAN := NVL (NOT to_file_in, TRUE);
      l_file        VARCHAR2 (1000) := NAME_IN || '.' || ext_in;

      -- Array of output for package
      TYPE lines_t IS TABLE OF VARCHAR2 (1000)
                         INDEX BY BINARY_INTEGER;

      output        lines_t;

      -- Now pl simply writes to the array.
      PROCEDURE pl (str IN VARCHAR2)
      IS
      BEGIN
         output (NVL (output.LAST, 0) + 1) := str;
      END;

      -- Dump to screen or file.
      PROCEDURE dump_output
      IS
      BEGIN
         IF l_to_screen
         THEN
            FOR indx IN output.FIRST .. output.LAST
            LOOP
               DBMS_OUTPUT.put_line (output (indx));
            END LOOP;
         ELSE
            -- Send output to the specified file.
            DECLARE
               fid   UTL_FILE.file_type;
            BEGIN
               fid := UTL_FILE.fopen (dir_in, l_file, 'W');

               FOR indx IN output.FIRST .. output.LAST
               LOOP
                  UTL_FILE.put_line (fid, output (indx));
               END LOOP;

               UTL_FILE.fclose (fid);
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.put_line (
                     'Failure to write output to ' || dir_in || '/' || l_file
                  );
                  UTL_FILE.fclose (fid);
            END;
         END IF;
      END dump_output;
   BEGIN
      pl ('CREATE OR REPLACE PACKAGE ' || NAME_IN);
      pl ('IS ');

      FOR msg_rec IN exc_20000
      LOOP
         IF exc_20000%ROWCOUNT > 1
         THEN
            pl (' ');
         END IF;

         pl ('   exc_' || msg_rec.msgname || ' EXCEPTION;');
         pl(   '   en_'
            || msg_rec.msgname
            || ' CONSTANT pls_integer := '
            || msg_rec.msgcode
            || ';');
         pl(   '   PRAGMA EXCEPTION_INIT (exc_'
            || msg_rec.msgname
            || ', '
            || msg_rec.msgcode
            || ');');
      END LOOP;

      pl ('END ' || NAME_IN || ';');
      pl ('/');

      dump_output;
   END;
END message_mgr;
/

/* Sample data to be used in package generation. */

BEGIN
   INSERT INTO message_mgr_table
       VALUES (
                  -20100
                , 'EXCEPTION'
                , 'Salary must be positive'
                , 'sal_is_not_positive'
              );

   INSERT INTO message_mgr_table
       VALUES (
                  -20200
                , 'EXCEPTION'
                , 'Employee too young'
                , 'emp_too_young'
              );

   COMMIT;
END;
/

BEGIN
   message_mgr.genpkg (NAME_IN => 'error_mgr'
                     , to_file_in => TRUE
                     , dir_in => 'TEMP'
                     , ext_in => 'pkg'
                      );
END;
/