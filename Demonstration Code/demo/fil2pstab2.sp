CREATE OR REPLACE PROCEDURE fil2pstab (
   loc IN VARCHAR2,
   fil IN VARCHAR2,
   pstab OUT plvtab.vc2000_table
   )
IS
   fid UTL_FILE.file_type;
   v_line PLV.dbmaxvc2;
   v_eof BOOLEAN;
BEGIN
   fid := UTL_FILE.fopen (loc, fil, 'R');
   
   LOOP
      get_nextline (fid, v_line, v_eof);
      EXIT WHEN v_eof;
      pstab (NVL (pstab.LAST, 0) + 1) := v_line;
   END LOOP;
   
   utl_file.fclose (fid);
END;

