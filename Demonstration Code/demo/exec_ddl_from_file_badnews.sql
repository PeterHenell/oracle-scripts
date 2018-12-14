/*
Exception section has more code in it than the executable section!
*/

CREATE OR REPLACE PROCEDURE exec_ddl_from_file (
   dir_in IN VARCHAR2
 , file_in IN VARCHAR2
)
IS
   l_file    UTL_FILE.file_type;
   l_lines   DBMS_SQL.varchar2a;
BEGIN
   l_file := UTL_FILE.fopen (dir_in, file_in, 'R');

   LOOP
      UTL_FILE.get_line (l_file, l_lines (l_lines.COUNT + 1));
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      UTL_FILE.fclose (l_file);

      DECLARE
         l_cur    PLS_INTEGER;
         l_exec   PLS_INTEGER;
      BEGIN
         l_cur := DBMS_SQL.open_cursor;
         DBMS_SQL.parse (l_cur
                       , l_lines
                       , l_lines.FIRST
                       , l_lines.LAST
                       , TRUE
                       , DBMS_SQL.native
                        );
         l_exec := DBMS_SQL.EXECUTE (l_cur);
         DBMS_SQL.close_cursor (l_cur);
      END;
END exec_ddl_from_file;
/

/* This feels much better.... */


CREATE OR REPLACE PROCEDURE exec_ddl_from_file (
   dir_in IN VARCHAR2
 , file_in IN VARCHAR2
)
IS
   l_file    UTL_FILE.file_type;
   l_eof     BOOLEAN;
   l_lines   DBMS_SQL.varchar2a;

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

   PROCEDURE exec_ddl_statement (lines_in IN DBMS_SQL.varchar2a)
   IS
      l_cur    PLS_INTEGER;
      l_exec   PLS_INTEGER;
   BEGIN
      l_cur := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (l_cur
                    , l_lines
                    , l_lines.FIRST
                    , l_lines.LAST
                    , TRUE
                    , DBMS_SQL.native
                     );
      l_exec := DBMS_SQL.EXECUTE (l_cur);
      DBMS_SQL.close_cursor (l_cur);
   END exec_ddl_statement;
BEGIN
   l_file := UTL_FILE.fopen (dir_in, file_in, 'R');

   LOOP
      get_next_line (l_lines (l_lines.COUNT + 1), l_eof);
      EXIT WHEN l_eof;
   END LOOP;

   UTL_FILE.fclose (l_file);
   exec_ddl_statement (l_lines);
EXCEPTION
   -- Handle common UTL_FILE and DBMS_SQL errors here!
   WHEN OTHERS
   THEN
      log_Error_and_reraise;
END exec_ddl_from_file;
/