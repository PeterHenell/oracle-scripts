REM @pl.sp

DECLARE
   fid UTL_FILE.FILE_TYPE;
   v VARCHAR2(32767);

   PROCEDURE recNgo (str IN VARCHAR2)
   IS
   BEGIN
      pl ('UTL_FILE error ' || str);
      UTL_FILE.FCLOSE (fid);
   END;
BEGIN
   /* Change the directory name to one to which you at least 
   || THINK you have read/write access.
   */
   fid := UTL_FILE.FOPEN ('e:\demo-seminar', '&&firstparm', 'R');
   UTL_FILE.GET_LINE (fid, v);
   pl (v);
   UTL_FILE.FCLOSE (fid);
   
   fid := UTL_FILE.FOPEN ('e:\demo-seminar', '&&secondparm', 'W');
   UTL_FILE.PUT_LINE (fid, v);
   UTL_FILE.FCLOSE (fid);
   
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH
    THEN recNgo ('invalid_path');
   WHEN UTL_FILE.INVALID_MODE
    THEN recNgo ('invalid_mode');
   WHEN UTL_FILE.INVALID_FILEHANDLE
    THEN recNgo ('invalid_filehandle');
   WHEN UTL_FILE.INVALID_OPERATION
    THEN recNgo ('invalid_operation');
   WHEN UTL_FILE.READ_ERROR
    THEN recNgo ('read_error');
   WHEN UTL_FILE.WRITE_ERROR
    THEN recNgo ('write_error');
   WHEN UTL_FILE.INTERNAL_ERROR
    THEN recNgo ('internal_error');

END;
/