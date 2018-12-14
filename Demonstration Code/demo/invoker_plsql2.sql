CONNECT hr/hr

CREATE DIRECTORY temp AS 'c:\temp'
/
GRANT WRITE ON DIRECTORY temp TO scott;
/

CREATE OR REPLACE FUNCTION format_line (line_in IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN UPPER (line_in);
END format_line;
/

CREATE OR REPLACE PROCEDURE write_to_file (
   dir_in IN VARCHAR2
 , file_name_in IN VARCHAR2
 , lines_in IN DBMS_SQL.varchar2s
)
AUTHID CURRENT_USER
IS
   l_file   UTL_FILE.file_type;
BEGIN
   l_file :=
      UTL_FILE.fopen (LOCATION          => dir_in
                    , filename          => file_name_in
                    , open_mode         => 'W'
                    , max_linesize      => 32767
                     );

   FOR indx IN 1 .. lines_in.COUNT
   LOOP
      UTL_FILE.put_line (l_file, format_line (lines_in (indx)));
   END LOOP;

   UTL_FILE.fclose (l_file);
END write_to_file;
/

GRANT EXECUTE ON write_to_file TO scott
/
CONNECT scott/tiger

CREATE OR REPLACE FUNCTION format_line (line_in IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN LOWER (line_in);
END format_line;
/

DECLARE
   l_lines   DBMS_SQL.varchar2s;
BEGIN
   l_lines (1) := 'steven feuerstein';
   l_lines (2) := 'is obsessed with PL/SQL.';
   hr.write_to_file ('TEMP', 'myfile.txt', l_lines);
END;
/

CONNECT hr/hr

CREATE OR REPLACE PROCEDURE write_to_file (
   dir_in IN VARCHAR2
 , file_name_in IN VARCHAR2
 , lines_in IN DBMS_SQL.varchar2s
)
AUTHID CURRENT_USER
IS
   l_file       UTL_FILE.file_type;
   l_newline   VARCHAR2 (32767);
BEGIN
   l_file :=
      UTL_FILE.fopen (LOCATION          => dir_in
                    , filename          => file_name_in
                    , open_mode         => 'W'
                    , max_linesize      => 32767
                     );

   FOR indx IN 1 .. lines_in.COUNT
   LOOP
      EXECUTE IMMEDIATE 'BEGIN :new_line := format_line (:old_line); END;'
                  USING OUT l_newline, IN lines_in (indx);

      UTL_FILE.put_line (l_file, l_newline);
   END LOOP;

   UTL_FILE.fclose (l_file);
END write_to_file;
/

GRANT EXECUTE ON write_to_file TO scott
/
CONNECT scott/tiger

DECLARE
   l_lines   DBMS_SQL.varchar2s;
BEGIN
   l_lines (1) := 'steven feuerstein';
   l_lines (2) := 'is obsessed with PL/SQL.';
   hr.write_to_file ('TEMP', 'myfile.txt', l_lines);
END;
/