DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', '100_lines.txt', 'W', max_linesize => 32767);

   FOR indx IN 1 .. 100
   LOOP
      UTL_FILE.
      put_line (fid, 'Line ' || indx || ' contains GUID ' || SYS_GUID ());
   END LOOP;

   UTL_FILE.fclose (fid);
END;
/

BEGIN
   -- Copy the entire file...
   UTL_FILE.
   fcopy (src_location => 'TEMP'
        , src_filename => '100_lines.txt'
        , dest_location => 'TEMP'
        , dest_filename => '100_lines_copy.txt'
         );
   display_file ('TEMP', '100_lines_copy.txt');

   -- Copy just a part of a file
   UTL_FILE.
   fcopy (src_location => 'TEMP'
        , src_filename => '100_lines.txt'
        , dest_location => 'TEMP'
        , dest_filename => '22_lines_copy.txt'
        , start_line => 22
        , end_line => 43
         );
   display_file ('TEMP', '22_lines_copy.txt');
END;
/
