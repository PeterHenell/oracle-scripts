DECLARE
   l_bfile         BFILE := BFILENAME ('DEMO', 'exec_ddl_from_file.sql');
   l_clob          CLOB;
   l_dest_offset   PLS_INTEGER := 1;
   l_src_offset    PLS_INTEGER := 1;
   l_context       PLS_INTEGER := 0;
   l_warning       PLS_INTEGER;
BEGIN
   /* Must create a lob locator and open the bfile */
   
   DBMS_LOB.createtemporary (l_clob, FALSE);
   DBMS_LOB.open (l_bfile, DBMS_LOB.file_readonly);
   
   /* Can use lobmaxsize to specify "entire bfile" */
   
   DBMS_LOB.loadclobfromfile (dest_lob       => l_clob
                            , src_bfile      => l_bfile
                            , amount         => DBMS_LOB.lobmaxsize
                            , dest_offset    => l_dest_offset
                            , src_offset     => l_src_offset
                            , bfile_csid     => 0
                            , lang_context   => l_context
                            , warning        => l_warning);
   DBMS_OUTPUT.put_line ('Clob length: ' || DBMS_LOB.getlength (l_clob));

   IF DBMS_LOB.INSTR (file_loc   => l_bfile
                    , pattern    => '123'
                    , offset     => 1
                    , nth        => 1) > 0
   THEN
      DBMS_OUTPUT.put_line ('Found 123');
   END IF;

   DBMS_OUTPUT.put_line (
      DBMS_LOB.SUBSTR (file_loc => l_bfile, amount => 5, offset => 1));
END;
/