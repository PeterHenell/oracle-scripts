@@getnext.sp
CREATE OR REPLACE PROCEDURE dispfile (
   dir IN VARCHAR2, file IN VARCHAR2)
IS
   fileid UTL_FILE.FILE_TYPE;
   line PLVfile.max_line%TYPE;
   eof BOOLEAN;
BEGIN
   /* Note: you must set delimiter and optionally directory
      for PLVfile for this to work! */
   fileid := UTL_file.fopen (dir, file, 'R');
   LOOP
      get_nextline (fileid, line, eof);
      EXIT WHEN eof;
      p.l (line);
   END LOOP;
   UTL_file.fclose (fileid);
EXCEPTION
   WHEN OTHERS
   THEN
      UTL_file.fclose (fileid);   
END;
/