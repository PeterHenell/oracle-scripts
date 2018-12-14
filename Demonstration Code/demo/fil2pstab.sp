CREATE OR REPLACE PROCEDURE fil2pstab (
   loc IN VARCHAR2,
   fil IN VARCHAR2,
   pstab OUT plvtab.vc2000_table
   )
IS
   fid UTL_FILE.file_type;
   v_line PLV.dbmaxvc2;
BEGIN
   fid := UTL_FILE.fopen (loc, fil, 'R');
   LOOP
      UTL_FILE.get_line (fid, v_line);
      pstab (NVL (pstab.LAST, 0) + 1) := v_line;
   END LOOP;
exception
   when no_data_found
   then
      utl_file.fclose (fid);
END;
