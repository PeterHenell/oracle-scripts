DECLARE
   fid UTL_FILE.FILE_TYPE;
BEGIN
   fid := UTL_FILE.FOPEN ('TEMP', 'test.txt', 'W');
   UTL_FILE.PUT_LINE (fid, 'UTL_FILE');
   UTL_FILE.PUT (fid, 'is so much fun');
   UTL_FILE.PUTF (fid, ' that I never\nwant to %s', 'stop!');
   UTL_FILE.FCLOSE (fid);
   display_file ('TEMP', 'test.txt');
END;
/

