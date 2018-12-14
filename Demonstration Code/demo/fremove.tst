DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'test.txt', 'W');
   UTL_FILE.put_line (fid, 'UTL_FILE');
   UTL_FILE.put (fid, 'is so much fun');
   UTL_FILE.putf (fid, ' that I never\nwant to %s', 'stop!');
   UTL_FILE.fclose (fid);
   display_file ('TEMP', 'test.txt');
END;
/

BEGIN
   fremove ('test.txt', 'TEMP', TRUE);
END;
/

BEGIN
   fremove ('test.txt', 'TEMP', TRUE);
END;
/