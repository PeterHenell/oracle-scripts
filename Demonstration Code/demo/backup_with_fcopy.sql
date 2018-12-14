DECLARE
   file_suffix   VARCHAR2 (100)
            := TO_CHAR (SYSDATE, 'YYYYMMDDHH24MISS'); /* Lysaker 10-2007 Need 24 */
BEGIN
   -- Copy the entire file...
   UTL_FILE.fcopy (
      src_location       => 'DEVELOPMENT_DIR',
      src_filename       => 'archive.zip',
      dest_location      => 'ARCHIVE_DIR',
      dest_filename      =>    'archive'
                            || file_suffix
                            || '.zip'
   );
   -- Copy just a part of a file
   UTL_FILE.fcopy (
      src_location       => 'WINNERS_DIR',
      src_filename       => 'names.txt',
      dest_location      => 'OLD_NEWS_DIR',
      dest_filename      => 'prevnames.txt',
      start_line         => 1,
      end_line           => 6
   );
END;

