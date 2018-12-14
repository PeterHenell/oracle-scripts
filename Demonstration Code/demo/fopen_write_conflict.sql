/* What happens if I try to open a file for W when
   it has already been opened?

   Run the first block in session 1 - it will pause for 15 seconds.
   Run the second block in another session   
*/

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'demo.txt', 'W', max_linesize => 32767);
   utl_file.put_line (fid, 'from session 1');
   DBMS_LOCK.sleep (15);
   UTL_FILE.fclose (fid);
END;
/

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'demo.txt', 'W', max_linesize => 32767);
   utl_file.put_line (fid, 'from session 2');
   UTL_FILE.fclose (fid);
END;
/

/* No problem! You just see the second line....*/

/* What about Append? */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'demo.txt', 'A', max_linesize => 32767);
   utl_file.put_line (fid, 'from session 1');
   DBMS_LOCK.sleep (15);
   UTL_FILE.fclose (fid);
END;
/

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'demo.txt', 'A', max_linesize => 32767);
   utl_file.put_line (fid, 'from session 2');
   UTL_FILE.fclose (fid);
END;
/

/* No problem! */
