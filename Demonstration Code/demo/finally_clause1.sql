CREATE OR REPLACE PROCEDURE exec_sql_from_file (
   dir_in    IN   VARCHAR2
 , file_in   IN   VARCHAR2
)
IS
   l_file    UTL_FILE.file_type;
   l_lines   DBMS_SQL.varchar2a;
   l_cur     PLS_INTEGER;
   l_exec    PLS_INTEGER;

   PROCEDURE cleanup
   IS
   BEGIN
      IF SQLCODE <> 0
      THEN
         log_error ();
      END IF;

      IF UTL_FILE.is_open (l_file)
      THEN
         UTL_FILE.fclose (l_file);
      END IF;

      IF DBMS_SQL.is_open (l_cur)
      THEN
         DBMS_SQL.close_cursor (l_cur);
      END IF;
   END cleanup;
BEGIN
   BEGIN
      l_file := UTL_FILE.fopen (dir_in, file_in, 'R');

      LOOP
         UTL_FILE.get_line (l_file, l_lines (l_lines.COUNT + 1));
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         /* All done reading the file. */
         NULL;
   END;

   l_cur := DBMS_SQL.open_cursor;
   DBMS_SQL.parse (l_cur
                 , l_lines
                 , l_lines.FIRST
                 , l_lines.LAST
                 , TRUE
                 , DBMS_SQL.native
                  );
   l_exec := DBMS_SQL.EXECUTE (l_cur);
   --
   cleanup;
EXCEPTION
   WHEN OTHERS
   THEN
      -- log_error ();
      cleanup ();
      RAISE;
END exec_sql_from_file;
/

/*
BEGIN
   exec_sql_from_file ('TEMP', 'finally_clause_test.sql');
END;
*/