CREATE OR REPLACE PROCEDURE compile_from_file (
   dir_in    IN   VARCHAR2
 , file_in   IN   VARCHAR2
)
AUTHID CURRENT_USER
IS
   l_file    UTL_FILE.file_type;
   l_cur     PLS_INTEGER        := DBMS_SQL.open_cursor;
   l_dummy   PLS_INTEGER;
   -- Use DBMS_SQL.varchar2s if Oracle version is earlier
   -- than Oracle Database 10g Release 10.1.
   l_lines   DBMS_SQL.varchar2a;

   PROCEDURE read_file (lines_out IN OUT DBMS_SQL.varchar2a)
   IS
   BEGIN
      l_file := UTL_FILE.fopen (dir_in, file_in, 'R');

      LOOP

         <<read_one_line>>
         BEGIN
            UTL_FILE.get_line (l_file, lines_out (lines_out.COUNT + 1));
         EXCEPTION
            -- Reached end of file.
            WHEN NO_DATA_FOUND
            THEN
               -- Strip off trailing /. It will cause compile problems.
               IF RTRIM (lines_out (lines_out.LAST)) = '/'
               THEN
                  lines_out.DELETE (lines_out.LAST);
               END IF;

               UTL_FILE.fclose (l_file);
               EXIT;
         END read_one_line;
      END LOOP;
   END read_file;
BEGIN
   read_file (l_lines);
   DBMS_SQL.parse (l_cur
                 , l_lines
                 , l_lines.FIRST
                 , l_lines.LAST
                 , TRUE
                 , DBMS_SQL.native
                  );
   l_dummy := DBMS_SQL.EXECUTE (l_cur);
   DBMS_SQL.close_cursor (l_cur);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Compile from ' || file_in || ' failed!');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);

      IF UTL_FILE.is_open (l_file)
      THEN
         UTL_FILE.fclose (l_file);
      END IF;

      IF DBMS_SQL.is_open (l_cur)
      THEN
         DBMS_SQL.close_cursor (l_cur);
      END IF;
END compile_from_file;
/