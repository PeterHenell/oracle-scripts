DECLARE
   file_handle   UTL_FILE.file_type;
   l_lines       DBMS_SQL.varchar2a;
BEGIN
   /*
   || Open the file, write a single line and close the file.
   */
   file_handle := UTL_FILE.fopen ('TEMP', 'temp.txt', 'W');
   UTL_FILE.fclose (file_handle);
   UTL_FILE.fclose (file_handle);
END;
/