CREATE OR REPLACE FUNCTION file_to_collection (dir_in  IN VARCHAR2
                                             , file_in IN VARCHAR2
                                              )
   RETURN DBMS_SQL.varchar2a
IS
   l_file    UTL_FILE.file_type;
   l_lines   DBMS_SQL.varchar2a;

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
   l_file := UTL_FILE.fopen (dir_in, file_in, 'R', max_linesize => 32767);

   WHILE (NOT l_eof)
   LOOP
      get_next_line (l_lines (l_lines.COUNT + 1), l_eof);
   END LOOP;

   UTL_FILE.fclose (l_file);
   RETURN l_lines;
EXCEPTION
   WHEN OTHERS
   THEN
      IF UTL_FILE.is_open (l_file)
      THEN
         UTL_FILE.fclose (l_file);
      END IF;

      RAISE;
END file_to_collection;
/

/* Demonstration */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'demo.txt', 'W', max_linesize => 32767);

   FOR indx IN 1 .. 100
   LOOP
      UTL_FILE.
      put_line (fid, 'Line ' || indx || ' contains GUID ' || SYS_GUID ());
   END LOOP;

   UTL_FILE.fclose (fid);
END;
/

DECLARE
   l_lines   DBMS_SQL.varchar2a;
BEGIN
  l_lines := file_to_collection ('TEMP', 'demo.txt');

   FOR indx IN 1 .. l_lines.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_lines (indx));
   END LOOP;
END;
/