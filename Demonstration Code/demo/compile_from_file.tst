CREATE OR REPLACE PROCEDURE compile_from_file_test (
   dir_in    IN   VARCHAR2
  ,file_in   IN   VARCHAR2
)
IS
   l_file    UTL_FILE.file_type;
   l_lines   DBMS_SQL.varchar2s;
   l_cur     PLS_INTEGER        := DBMS_SQL.open_cursor;
BEGIN
   l_file := UTL_FILE.fopen (dir_in, file_in, 'R');

   BEGIN
      LOOP
         UTL_FILE.get_line (l_file, l_lines (l_lines.COUNT + 1));
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   DBMS_SQL.parse (l_cur
                  ,l_lines
                  ,l_lines.FIRST
                  ,l_lines.LAST
                  ,TRUE
                  ,DBMS_SQL.native
                  );
   DBMS_SQL.close_cursor (l_cur);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_SQL.close_cursor (l_cur);
      DBMS_OUTPUT.put_line ('Compile from file failure: ');
      DBMS_OUTPUT.put_line (SUBSTR (SQLERRM, 1, 255));
END compile_from_file_test ;
/