CREATE OR REPLACE PROCEDURE collection_to_file (
   dir_in     IN VARCHAR2,
   file_in    IN VARCHAR2,
   lines_in   IN DBMS_SQL.varchar2a)
IS
   l_file    UTL_FILE.file_type;
   l_lines   DBMS_SQL.varchar2a;
   indx      INTEGER := lines_in.FIRST;

   l_eof     BOOLEAN := FALSE;

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
      UTL_FILE.fopen (dir_in,
                      file_in,
                      'W',
                      max_linesize   => 32767);

   WHILE (indx IS NOT NULL)
   LOOP
      UTL_FILE.put_line (l_file, lines_in (indx));
      indx := lines_in.NEXT (indx);
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
END collection_to_file;
/