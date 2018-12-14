DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'test.txt', 'W');

   FOR indx IN 1 .. 10
   LOOP
      UTL_FILE.put_line (
         fid
       ,  RPAD ('0123456789', 100, '0123456789'));
   END LOOP;

   UTL_FILE.fclose (fid);
END;
/

DECLARE
   l_file   UTL_FILE.file_type;
   l_line   VARCHAR2 (32767);
BEGIN
   l_file :=
      UTL_FILE.fopen ('TEMP'
                    ,  'test.txt'
                    ,  'R'
                    ,  max_linesize   => 32767);

   FOR indx IN 1 .. 10
   LOOP
      UTL_FILE.get_line (l_file, l_line, indx);
      DBMS_OUTPUT.put_line (l_line);
   END LOOP;

   UTL_FILE.fclose (l_file);
END;
/