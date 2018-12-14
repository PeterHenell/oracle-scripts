-- USE DIRECTORY

-- Get yor DBA to do this for you before you start
-- It's necessary to connect as SYS to grant SELECT on the
-- [tables underlying] the V$ views
--
-- It's assumed that the shipped HR schema has been installed,
-- that SELECT has been granted on EMPLOYEES to PUBLIC and
-- that a public synonym has been created for EMPLOYEES

CONNECT sys/sys as sysdba

GRANT
  RESOURCE,
  CONNECT
  TO programmer IDENTIFIED BY programmer
/
GRANT SELECT ON v_$parameter TO programmer
/
GRANT EXECUTE ON DBMS_PIPE TO programmer
/

DECLARE
   v_stmt   VARCHAR2 (4000);
BEGIN
   -- use the udump dir for convenience
   SELECT VALUE
     INTO v_stmt
     FROM v$parameter
    WHERE name = 'user_dump_dest';

   v_stmt :=
      'create or replace directory UTL_FILE_TEST as ''' || v_stmt || '''';

   EXECUTE IMMEDIATE v_stmt;
END;
/

GRANT READ ON DIRECTORY utl_file_test TO programmer
/
CONNECT programmer/programmer

SELECT directory_path
  FROM all_directories
 WHERE directory_name = 'UTL_FILE_TEST'
/

/*
DIRECTORY_PATH
----------------------------------
.../oracle/admin/[mysid]/udump
*/

-- DEMO Opening, writing and closing

SET SERVEROUTPUT ON

DECLARE
   v_line                VARCHAR2 (32767);
   c_location   CONSTANT VARCHAR2 (80) := 'UTL_FILE_TEST';
   c_filename   CONSTANT VARCHAR2 (80) := 'test.txt';
   v_handle              UTL_FILE.file_type;

   PROCEDURE show_is_open
   IS
   BEGIN
      CASE UTL_FILE.is_open (file => v_handle)
         WHEN TRUE
         THEN
            DBMS_OUTPUT.put_line ('open');
         ELSE
            DBMS_OUTPUT.put_line ('closed');
      END CASE;
   END show_is_open;

   PROCEDURE put_line
   IS
   BEGIN
      UTL_FILE.put_line (file        => v_handle
                       , buffer      => 'Hello world'
                       , autoflush   => FALSE);
   END put_line;
BEGIN
   -- Oracle recommends that you always use max_linesize => 32767
   -- This is a "magic number" which prevents error if the
   -- linesize exceeds max_linesize (character file) or if the file size
   -- exceeds max_linesize (binary file).
   --
   -- If the file is treated as character data, then max_linesize must be
   -- no smaller than the longest line. Else exception when a line
   -- is attempted read whose length exceeds max_linesize
   -- UNLESS max_linesize is 32767
   --
   -- If the file is treated as binary data, then max_linesize must be
   -- no smaller than the size of the file
   -- UNLESS max_linesize is 32767

   /* write over any existing file with this name */
   v_handle :=
      UTL_FILE.fopen (location       => c_location
                    , filename       => c_filename
                    , open_mode      => 'w'
                    , max_linesize   => 32767);
   show_is_open;
   put_line;
   UTL_FILE.fclose (file => v_handle);
   show_is_open;
--Put_Line /* uncomment to see Utl_File.Invalid_Filehandle */;
EXCEPTION
   WHEN                                -- ORA-29287: invalid maximum line size
       UTL_FILE.invalid_maxlinesize
   THEN
      -- Fclose_All closes all open files for this session.
      -- It is for cleanup use only. File handles will not be cleared
      -- (Is_Open will still indicate they are valid)
      UTL_FILE.fclose_all;
      raise_application_error (-20000, 'Invalid_Maxlinesize trapped');
   WHEN                                          -- ORA-29282: invalid file ID
       UTL_FILE.invalid_filehandle
   THEN
      UTL_FILE.fclose_all;
      raise_application_error (-20000, 'Invalid_Filehandle trapped');
END;
/

-- DEMO	Mimicing Unix  ls, cp, mv, rm

SET SERVEROUTPUT ON

DECLARE
   v_line                       VARCHAR2 (32767);
   c_location          CONSTANT VARCHAR2 (80) := 'UTL_FILE_TEST';
   c_source_filename   CONSTANT VARCHAR2 (80) := 'test.txt';
   c_copy_filename     CONSTANT VARCHAR2 (80) := 'copy.txt';
   c_ren_filename      CONSTANT VARCHAR2 (80) := 'ren.txt';

   PROCEDURE show_attr (p_filename IN VARCHAR2)
   IS
      v_exists        BOOLEAN;
      v_file_length   NUMBER;
      v_block_size    BINARY_INTEGER;
   BEGIN
      UTL_FILE.fgetattr (location      => c_location
                       , filename      => p_filename
                       , fexists       => v_exists
                       , file_length   => v_file_length
                       , block_size    => v_block_size);

      -- Bug #2240685. v_exists is always returned TRUE
      -- But non-existent file has ZERO file_length and block_size
      IF NOT v_exists
      THEN
         raise_application_error (-20000, 'Bug #2240685 is fixed');
      END IF;

      DBMS_OUTPUT.put_line (
            p_filename
         || ' : '
         || TO_CHAR (v_file_length)
         || ' : '
         || TO_CHAR (v_block_size));
   END show_attr;

   PROCEDURE remove (p_filename IN VARCHAR2)
   IS
   BEGIN
      UTL_FILE.fremove (location => c_location, filename => p_filename);
   EXCEPTION
      WHEN UTL_FILE.delete_failed
      THEN
         UTL_FILE.fclose_all;
         raise_application_error (-20000, 'Fremove: Delete_Failed trapped');
      WHEN UTL_FILE.invalid_operation
      THEN
         UTL_FILE.fclose_all;
         raise_application_error (-20000
                                , 'Fremove: Invalid_Operation trapped');
   END remove;

   PROCEDURE full_copy (p_source IN VARCHAR2, p_dest IN VARCHAR2)
   IS
   BEGIN
      UTL_FILE.fcopy (src_location    => c_location
                    , src_filename    => p_source
                    , dest_location   => c_location
                    , dest_filename   => p_dest);
   EXCEPTION
      WHEN UTL_FILE.invalid_operation
      THEN
         UTL_FILE.fclose_all;
         raise_application_error (-20000, 'Fcopy: Invalid_Operation trapped');
   END full_copy;

   PROCEDURE rename (p_source IN VARCHAR2, p_dest IN VARCHAR2)
   IS
   BEGIN
      UTL_FILE.frename (src_location    => c_location
                      , src_filename    => p_source
                      , dest_location   => c_location
                      , dest_filename   => p_dest
                      , overwrite       => FALSE);
   EXCEPTION
      WHEN UTL_FILE.rename_failed
      THEN
         UTL_FILE.fclose_all;
         raise_application_error (-20000, 'Frename: Rename_Failed trapped');
   END rename;
BEGIN
   show_attr (c_source_filename);
   show_attr (c_copy_filename);
   full_copy (c_source_filename, c_copy_filename);
   --Full_Copy ( 'not_there.txt', c_copy_filename ) /* Uncomment to see Utl_File.Invalid_Operation */;
   show_attr (c_copy_filename);
   -- Create ren.txt before running this block to see Utl_File.Rename_Failed
   rename (c_copy_filename, c_ren_filename);
   show_attr (c_ren_filename);
   remove (c_ren_filename);
-- Create protected.txt by hand and do "chmod a-x protected.txt"
--Remove ( 'protected.txt' ) /* Uncomment to see Utl_File.Invalid_Operation */;
END;
/