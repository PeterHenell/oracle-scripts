DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'temp.txt', 'W', max_linesize => 32767);

   display_header ('FGETPOS when writing');

   FOR indx IN 1 .. 10
   LOOP
      UTL_FILE.
      put_line (fid, 'Line ' || indx || ' contains GUID ' || SYS_GUID ());
      DBMS_OUTPUT.put_line (UTL_FILE.fgetpos (fid));
   END LOOP;

   UTL_FILE.fclose (fid);
END;
/

DECLARE
   fid      UTL_FILE.file_type;
   l_line   VARCHAR2 (32767);
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'temp.txt', 'R', max_linesize => 32767);
   display_header ('FGETPOS when reading');

   FOR indx IN 1 .. 10
   LOOP
      UTL_FILE.get_line (fid, l_line);
      DBMS_OUTPUT.put_line (UTL_FILE.fgetpos (fid));
   END LOOP;

   UTL_FILE.fclose (fid);
END;
/