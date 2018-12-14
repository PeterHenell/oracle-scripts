DECLARE
   l_bfile   BFILE := BFILENAME ('DEMO', 'exec_ddl_from_file.sql');
   l_dir     VARCHAR2 (1000);
   l_name    VARCHAR2 (1000);
BEGIN
   DBMS_OUTPUT.put_line ('Exists? ' || DBMS_LOB.fileexists (l_bfile));
   DBMS_LOB.fileopen (l_bfile);
   DBMS_OUTPUT.put_line ('Is open? ' || DBMS_LOB.fileisopen (l_bfile));
   DBMS_OUTPUT.put_line ('File length: ' || DBMS_LOB.getlength (l_bfile));
   DBMS_LOB.filegetname (l_bfile, l_dir, l_name);
   DBMS_OUTPUT.put_line ('BFILE points to ' || l_dir || '\' || l_name);
   DBMS_LOB.fileclose (l_bfile);
END;