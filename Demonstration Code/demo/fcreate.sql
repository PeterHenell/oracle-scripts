DECLARE
   fid UTL_FILE.FILE_TYPE;
BEGIN
   fid := PLVfile.fcreate ('/tmp', 'temp.dat', 'W');

   PLVfile.fclose (fid);
END;
/

PLVfile.fcreate ('/tmp', 'temp.dat');