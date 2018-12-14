CREATE OR REPLACE PROCEDURE display_file (dir_in    IN VARCHAR2
                                        , file_in   IN VARCHAR2)
IS
   l_file   UTL_FILE.file_type;
   l_line   VARCHAR2 (32767);

   l_eof    BOOLEAN := FALSE;

   PROCEDURE get_next_line (line_out OUT VARCHAR2, eof_out OUT BOOLEAN)
   IS
   BEGIN
      UTL_FILE.get_line (l_file, line_out);
      eof_out := FALSE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         line_out := NULL;
         eof_out := TRUE;
   END get_next_line;
BEGIN
   l_file :=
      UTL_FILE.fopen (dir_in
                    , file_in
                    , 'R'
                    , max_linesize   => 32767);
   display_header ('Contents of ' || file_in || ' located in ' || dir_in);

   LOOP
      get_next_line (l_line, l_eof);
      EXIT WHEN l_eof;
      DBMS_OUTPUT.put_line (l_line);
   END LOOP;

   UTL_FILE.fclose (l_file);
EXCEPTION
   WHEN OTHERS
   THEN
      IF UTL_FILE.is_open (l_file)
      THEN
         UTL_FILE.fclose (l_file);
      END IF;

      RAISE;
END display_file;
/

/* Demonstration */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid :=
      UTL_FILE.fopen ('TEMP'
                    , 'demo.txt'
                    , 'W'
                    , max_linesize   => 32767);

   FOR indx IN 1 .. 100
   LOOP
      UTL_FILE.put_line (fid
                       , 'Line ' || indx || ' contains GUID ' || SYS_GUID ());
   END LOOP;

   UTL_FILE.fclose (fid);
END;
/

BEGIN
   DBMS_OUTPUT.enable (1000000);
   display_file ('TEMP', 'demo.txt');
END;
/