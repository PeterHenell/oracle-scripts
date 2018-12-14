/* Formatted on 2002/09/11 21:32 (Formatter Plus v4.7.0) */

DECLARE
   v_record                 CHAR (80);
   c_record_size   CONSTANT BINARY_INTEGER     := 80;
   v_raw                    RAW (32767);
   v_raw_size      CONSTANT BINARY_INTEGER     := 32767;
   v_handle                 UTL_FILE.file_type;
   c_location      CONSTANT VARCHAR2 (80)      := 'UTL_FILE_TEST';
   c_filename      CONSTANT VARCHAR2 (80)      := 'dest.jpg';

   PROCEDURE put_raw (p_text IN VARCHAR2)
   IS
   BEGIN
      v_record := p_text;
      v_raw := UTL_RAW.cast_to_raw (v_record);
      UTL_FILE.put_raw (
         FILE           => v_handle,
         buffer         => v_raw,
         autoflush      => FALSE
      );
   END put_raw;

   PROCEDURE get_raw (p_offset IN BINARY_INTEGER)
   IS
   BEGIN
      UTL_FILE.fseek (FILE => v_handle, absolute_offset => p_offset);
      UTL_FILE.get_raw (
         FILE        => v_handle,
         buffer      => v_raw,
         len         => c_record_size
      );
      DBMS_OUTPUT.put_line (UTL_RAW.cast_to_varchar2 (v_raw));
   END get_raw;
BEGIN
   v_handle := UTL_FILE.fopen (
                  LOCATION          => c_location,
                  filename          => c_filename,
                  open_mode         => 'w' /* Create for writing */,
                  max_linesize      => v_raw_size
               );
   put_raw ('Mary had a little lamb');
   put_raw ('The cat sat on the mat');
   put_raw ('The quick brown fox jumped over the lazy dog');
   UTL_FILE.fclose (FILE => v_handle);
   v_handle := UTL_FILE.fopen (
                  LOCATION          => c_location,
                  filename          => c_filename,
                  open_mode         => 'r' /* Re-open for reading */,
                  max_linesize      => v_raw_size
               );
   get_raw (2 * c_record_size - 1);
   get_raw (0);
   UTL_FILE.fclose (FILE => v_handle);
END;