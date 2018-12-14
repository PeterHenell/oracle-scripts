/* Create a file with a line of text. */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'test.txt', 'W');
   UTL_FILE.put_line (fid, RPAD ('abc', 1000, '123'));
   UTL_FILE.fclose (fid);
END;
/

/* Now read and display the line. */

DECLARE
   fid      UTL_FILE.file_type;
   l_line   VARCHAR2 (32767);
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'test.txt', 'R');
   UTL_FILE.get_line (fid, l_line);
   DBMS_OUTPUT.put_line (l_line);
   UTL_FILE.fclose (fid);
END;
/

/* What if I specify a linesize that is too small? */

DECLARE
   fid      UTL_FILE.file_type;
   l_line   VARCHAR2 (32767);
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'test.txt', 'R', max_linesize => 25);
   UTL_FILE.get_line (fid, l_line);
   DBMS_OUTPUT.put_line (l_line);
   UTL_FILE.fclose (fid);
END;
/
