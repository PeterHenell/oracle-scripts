DECLARE
   fid UTL_FILE.FILE_TYPE;

   PROCEDURE recNgo (str IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('UTL_FILE error: ' || str);
      UTL_FILE.FCLOSE (fid);
   END;
BEGIN
	fid := UTL_FILE.FOPEN ('c:\temp', 'nonexistent.file', 'R');
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
   WHEN OTHERS
    THEN recNgo (SQLERRM); /* TVP 9/2000 */
END;
/
