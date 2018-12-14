DECLARE
   fid UTL_FILE.FILE_TYPE;
BEGIN
   fid := UTL_FILE.FOPEN ('c:\temp', 'new.txt', 'W');
   UTL_FILE.PUT_LINE (fid, 'blah');
   UTL_FILE.FCLOSE (fid);
END;
/
BEGIN
   PLVfile.fcreate ('c:\temp', 'new.txt');
END;
/
DECLARE
   fid UTL_FILE.FILE_TYPE;
BEGIN
   fid := PLVfile.fcreate ('c:\temp', 'new.txt');

   UTL_FILE.FCLOSE (fid);
END;
/
