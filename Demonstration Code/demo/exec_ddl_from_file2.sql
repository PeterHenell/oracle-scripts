CREATE OR REPLACE PROCEDURE exec_ddl_from_file (
   dir_in    IN   VARCHAR2
 , file_in   IN   VARCHAR2
)
AUTHID CURRENT_USER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   l_file    UTL_FILE.file_type;
   l_cur     PLS_INTEGER        := DBMS_SQL.open_cursor;
   l_dummy   PLS_INTEGER;
   -- Use DBMS_SQL.varchar2s if Oracle version is earlier
   -- than Oracle Database 10g Release 10.1.
   l_lines   DBMS_SQL.varchar2a;

   FUNCTION invoker_rights_mode
      RETURN BOOLEAN
   IS
      -- Original idea from Solomon Yakobson
      v_retval   NUMBER;
   BEGIN
      RETURN SYS_CONTEXT ('USERENV', 'SESSION_USER') =
                                      SYS_CONTEXT ('USERENV', 'CURRENT_USER');
   END;

   PROCEDURE read_file (lines_out IN OUT DBMS_SQL.varchar2a)
   IS
   BEGIN
      l_file := UTL_FILE.fopen (dir_in, file_in, 'R');

      LOOP
         UTL_FILE.get_line (l_file, lines_out (lines_out.COUNT + 1));
      END LOOP;
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
   END read_file;
BEGIN
   IF (NOT invoker_rights_mode)
   THEN
      raise_application_error
                     (-20999
                    , 'Exec DDL from file must run under invoker privileges!'
                     );
   END IF;

   read_file (l_lines);
   DBMS_SQL.parse (l_cur
                 , l_lines
                 , l_lines.FIRST
                 , l_lines.LAST
                 , TRUE
                 , DBMS_SQL.native
                  );
   l_dummy := DBMS_SQL.EXECUTE (l_cur);
   --
   -- You can even determine the type of statement executed
   -- by calling the DBMS_SQL.last_sql_function_code function
   -- immediately after you execute the statement. Check the
   -- Oracle Call Interface Programmer's Guide for an explanation
   -- of the codes returned.
   DBMS_OUTPUT.put_line (   'Type of statement executed: '
                         || DBMS_SQL.last_sql_function_code ()
                        );
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
END exec_ddl_from_file;
/

GRANT EXECUTE ON exec_ddl_from_file TO PUBLIC
/
CREATE PUBLIC SYNONYM exec_ddl_from_file FOR exec_ddl_from_file
/