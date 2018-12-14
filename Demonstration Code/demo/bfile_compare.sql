DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'file1.txt', 'W', max_linesize => 32767);

   FOR indx IN 1 .. 5
   LOOP
      /* 11 characters per line */
      UTL_FILE.put_line (fid, 'Line ' || indx || ' same');
   END LOOP;

   FOR indx IN 1 .. 5
   LOOP
      UTL_FILE.put_line (fid, 'Line ' || indx || ' ' || SYS_GUID);
   END LOOP;

   UTL_FILE.fclose (fid);
END;
/

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid := UTL_FILE.fopen ('TEMP', 'file2.txt', 'W', max_linesize => 32767);

   FOR indx IN 1 .. 5
   LOOP
      UTL_FILE.put_line (fid, 'Line ' || indx || ' same');
   END LOOP;

   FOR indx IN 1 .. 5
   LOOP
      UTL_FILE.put_line (fid, 'Line ' || indx || ' ' || SYS_GUID);
   END LOOP;

   UTL_FILE.fclose (fid);
END;
/

DECLARE
   l_bfile1   BFILE := BFILENAME ('TEMP', 'file1.txt');
   l_bfile2   BFILE := BFILENAME ('TEMP', 'file2.txt');
BEGIN
   DBMS_LOB.fileopen (l_bfile1);

   DBMS_LOB.fileopen (l_bfile2);

   /* Look at portions of files that are the same */
   
   DBMS_OUTPUT.
   put_line (
      'Equal? '
      || DBMS_LOB.
         compare (file_1 => l_bfile1
                , file_2 => l_bfile2
                , amount => 33
                , offset_1 => 1
                , offset_2 => 1
                 )
   );

   /* Look at portions of files that are different */
   
   DBMS_OUTPUT.
   put_line (
      'Equal? '
      || DBMS_LOB.
         compare (file_1 => l_bfile1
                , file_2 => l_bfile2
                , amount => 33
                , offset_1 => 55
                , offset_2 => 25
                 )
   );
   
   /* Compare the entire files */
   
   DBMS_OUTPUT.
   put_line (
      'Equal with all defaults? '
      || DBMS_LOB.
         compare (file_1 => l_bfile1
                , file_2 => l_bfile2
                , amount => 18446744073709551615
                 )
   ); 
   
   DBMS_OUTPUT.
   put_line (
      'Equal with all defaults? '
      || DBMS_LOB.
         compare (file_1 => l_bfile1
                , file_2 => l_bfile2
                , amount => dbms_lob.lobmaxsize
                 )
   );   
     

   DBMS_LOB.fileclose (l_bfile1);
   DBMS_LOB.fileclose (l_bfile2);
END;
/
