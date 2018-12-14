CREATE OR REPLACE PROCEDURE upd_from_file2 
   (loc IN VARCHAR2, file IN VARCHAR2)
IS
   fid UTL_FILE.FILE_TYPE;
   v_line VARCHAR2(2000);
   v_space PLS_INTEGER;

BEGIN
   fid := UTL_FILE.FOPEN (loc, file, 'R');

   BEGIN
      LOOP
         UTL_FILE.GET_LINE (fid, v_line);
         v_space := INSTR (v_line, ' ', 1, 1);

         UPDATE emp SET sal = TO_NUMBER (SUBSTR (v_line, v_space+1))
          WHERE empno = TO_NUMBER (SUBSTR (v_line, 1, v_space-1));
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         UTL_FILE.FCLOSE (fid);
   END;
END;
/