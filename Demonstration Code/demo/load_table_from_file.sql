CREATE OR REPLACE DIRECTORY temp_dir AS 'c:\temp'
/
CREATE TABLE from_file (line VARCHAR2(4000))
/

DECLARE
   fid          UTL_FILE.file_type;
   line         VARCHAR2 (4000);
   v_currloc    INTEGER            := 1;
   v_delimloc   INTEGER            := 0;
   v_colnum     INTEGER            := 1;
BEGIN
   fid := UTL_FILE.fopen ('TEMP_DIR', 'FILENAME', 'R', max_linesize => 4000);

   LOOP
      BEGIN
         UTL_FILE.get_line (fid, line);

         INSERT INTO from_file
              VALUES (line);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXIT;
      END;
   END LOOP;

   UTL_FILE.fclose (fid);
   COMMIT;
END;
/