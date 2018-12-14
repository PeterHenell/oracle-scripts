CREATE OR REPLACE PROCEDURE read_and_write (
   read_file_in    IN   VARCHAR2
  ,read_dir_in     IN   VARCHAR2
  ,write_file_in   IN   VARCHAR2
  ,write_dir_in    IN   VARCHAR2
)
IS
   l_file_in    UTL_FILE.file_type;
   l_file_out   UTL_FILE.file_type;
   l_line       VARCHAR2 (32767);
   l_eof        BOOLEAN;

   PROCEDURE get_next_line_from_file (
      file_in    IN       UTL_FILE.file_type
     ,line_out   OUT      VARCHAR2
     ,eof_out    OUT      BOOLEAN
   )
   IS
   BEGIN
      UTL_FILE.get_line (file_in, line_out);
      eof_out := FALSE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         line_out := NULL;
         eof_out := TRUE;
   END get_next_line_from_file;
BEGIN
   l_file_in :=
      UTL_FILE.fopen (LOCATION          => read_dir_in
                     ,filename          => read_file_in
                     ,open_mode         => 'R'
                     ,max_linesize      => 32767
                     );
   l_file_out :=
      UTL_FILE.fopen (LOCATION          => read_dir_in
                     ,filename          => read_file_in
                     ,open_mode         => 'W'
                     ,max_linesize      => 32767
                     );

   LOOP
      get_next_line_from_file (l_file_in, l_line, l_eof);

      -- You must specify the condition for which the line is written to the output file.
      IF TRUE
      THEN
         UTL_FILE.put_line (l_file_out, l_line);
      END IF;

      EXIT WHEN l_eof;
   END LOOP;

   UTL_FILE.fclose (l_file_in);
   UTL_FILE.fclose (l_file_out);
EXCEPTION
   WHEN OTHERS
   THEN
      UTL_FILE.fclose (l_file_in);
      UTL_FILE.fclose (l_file_out);
      RAISE;
END read_and_write;
/