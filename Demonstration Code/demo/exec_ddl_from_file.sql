CREATE OR REPLACE PROCEDURE exec_ddl_from_file (
   dir_in    IN   VARCHAR2
 , file_in   IN   VARCHAR2
)
AUTHID CURRENT_USER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   l_cur     PLS_INTEGER        := DBMS_SQL.open_cursor;
   l_file    UTL_FILE.file_type;
   l_dummy   PLS_INTEGER;
   l_start   PLS_INTEGER;
   l_end     PLS_INTEGER;
   -- Use DBMS_SQL.varchar2s if Oracle version is earlier
   -- than Oracle Database 10g Release 10.1.
   l_lines   DBMS_SQL.varchar2a;                      -- 32767 chars per line

   --l_lines DBMS_SQL.varchar2s; -- 255 chars per line
   PROCEDURE get_next_line (
      line_out OUT VARCHAR2, eof_out OUT BOOLEAN)
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

   PROCEDURE read_file (lines_out IN OUT DBMS_SQL.varchar2a)
   IS
      l_eof   BOOLEAN := FALSE;
   BEGIN
      l_file := UTL_FILE.fopen (dir_in, file_in, 'R', max_linesize => 32767);

      WHILE (NOT l_eof)
      LOOP
         get_next_line (lines_out (lines_out.COUNT + 1), l_eof);
      END LOOP;

      UTL_FILE.fclose (l_file);
   END read_file;
BEGIN
   read_file (l_lines);
   l_start := 1;

   WHILE (l_lines.COUNT > 0)
   LOOP
      -- get next set of lines up to / all by itself.
      l_end := l_start;

      BEGIN
         WHILE (l_lines (l_end) <> '/' OR l_lines (l_end) IS NULL)
         LOOP
            l_end := l_end + 1;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            /* Reached end of array. Do the last block. */
            NULL;
      END;

      /* Do not include the / symbol. */
      DBMS_SQL.parse (l_cur
                    , l_lines
                    , l_start
                    , l_end - 1
                    , TRUE
                    , DBMS_SQL.native
                     );
      l_dummy := DBMS_SQL.EXECUTE (l_cur);
      /* You can even determine the type of statement executed
         by calling the DBMS_SQL.last_sql_function_code function
         immediately after you execute the statement. Check the
         Oracle Call Interface Programmer's Guide for an explanation
         of the codes returned. */
      DBMS_OUTPUT.put_line (   'Type of statement executed: '
                            || DBMS_SQL.last_sql_function_code ()
                           );
      l_lines.DELETE (l_start, l_end);
      /* Move past the / */
      l_start := l_end + 1;
   END LOOP;

   DBMS_SQL.close_cursor (l_cur);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Compile from ' || file_in || ' failed!');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace);

      IF UTL_FILE.is_open (l_file)
      THEN
         UTL_FILE.fclose (l_file);
      END IF;

      IF DBMS_SQL.is_open (l_cur)
      THEN
         DBMS_SQL.close_cursor (l_cur);
      END IF;

      RAISE;
END exec_ddl_from_file;
/

GRANT EXECUTE ON exec_ddl_from_file TO PUBLIC
/
CREATE PUBLIC SYNONYM exec_ddl_from_file FOR exec_ddl_from_file
/