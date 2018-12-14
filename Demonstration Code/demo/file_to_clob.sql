CREATE OR REPLACE FUNCTION file_to_clob (dir_in    IN VARCHAR2
                                       , file_in   IN VARCHAR2)
   RETURN CLOB
IS
   l_file   UTL_FILE.file_type;
   l_line   VARCHAR2 (32767);
   l_eof    BOOLEAN := FALSE;
   l_clob   CLOB;

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
   DBMS_LOB.createtemporary (l_clob, TRUE, DBMS_LOB.call);

   LOOP
      get_next_line (l_line, l_eof);
      EXIT WHEN l_eof;
      DBMS_LOB.writeappend (l_clob, LENGTH (l_line) + 1, l_line || CHR (10));
   END LOOP;

   UTL_FILE.fclose (l_file);
   RETURN l_clob;
EXCEPTION
   WHEN OTHERS
   THEN
      IF UTL_FILE.is_open (l_file)
      THEN
         UTL_FILE.fclose (l_file);
      END IF;

      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace ());
      RAISE;
END file_to_clob;
/