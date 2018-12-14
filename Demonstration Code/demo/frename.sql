DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'fcopy.txt', 'W');
   UTL_FILE.put_line (fid, 'UTL_FILE');
   UTL_FILE.put (fid, 'is so much fun');
   UTL_FILE.putf (fid, ' that I never\nwant to %s', 'stop!');
   UTL_FILE.fclose (fid);
END;
/

/* Copy to file with different name */

BEGIN
   UTL_FILE.frename (src_location    => 'TEMP'
                   , src_filename    => 'fcopy.txt'
                   , dest_location   => 'DEMO'
                   , dest_filename   => 'fcopy_backup.txt'
                   , overwrite       => TRUE);
END;
/

/* Move to a different directory */

BEGIN
   UTL_FILE.frename (src_location    => 'TEMP'
                   , src_filename    => 'fcopy.txt'
                   , dest_location   => 'DEMO'
                   , dest_filename   => 'fcopy.txt'
                   , overwrite       => TRUE);
END;
/

/* What if file exists and I do not overwrite? */

BEGIN
   UTL_FILE.frename (src_location    => 'TEMP'
                   , src_filename    => 'fcopy.txt'
                   , dest_location   => 'DEMO'
                   , dest_filename   => 'fcopy.txt'
                   , overwrite       => false);
END;
/