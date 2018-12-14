DECLARE
   l_bfile      BFILE := BFILENAME ('DEMO', 'exec_ddl_from_file.sql');
   l_contents   RAW (32767);
   l_amount     PLS_INTEGER := 100;
BEGIN
   DBMS_LOB.fileopen (l_bfile);
   
   DBMS_LOB.read (file_loc   => l_bfile
                , amount     => l_amount
                , offset     => 1
                , buffer     => l_contents);
                
   DBMS_OUTPUT.put_line (l_contents);
   DBMS_LOB.fileclose (l_bfile);
END;