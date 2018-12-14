CREATE OR REPLACE PROCEDURE exec_ddl_from_file (dir_in    IN VARCHAR2
                                              , file_in   IN VARCHAR2)
IS
   l_file   UTL_FILE.file_type;
   l_eof    BOOLEAN;
   l_line   VARCHAR2 (32767);
   l_ddl    CLOB;

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
   l_file := UTL_FILE.fopen (dir_in, file_in, 'R');

   LOOP
      get_next_line (l_line, l_eof);
      EXIT WHEN l_eof;
      l_ddl := l_ddl || CHR (10) || l_line;
   END LOOP;

   UTL_FILE.fclose (l_file);

   EXECUTE IMMEDIATE l_ddl;
END exec_ddl_from_file;
/