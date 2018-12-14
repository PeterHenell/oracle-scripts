DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'test.txt', 'W', max_linesize => 32767);

   IF UTL_FILE.is_open (fid)
   THEN
      DBMS_OUTPUT.put_line ('File is open');
   ELSE
      DBMS_OUTPUT.put_line ('File is closed');
   END IF;

   UTL_FILE.fclose (fid);
END;