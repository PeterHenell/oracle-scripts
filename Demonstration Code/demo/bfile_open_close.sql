DECLARE
   l_bfile   BFILE := BFILENAME ('DEMO', 'exec_ddl_from_file2.sql');
BEGIN
   DBMS_OUTPUT.put_line ('Exists? ' || DBMS_LOB.fileexists (l_bfile));
   DBMS_OUTPUT.put_line ('Is open before open? ' || DBMS_LOB.fileisopen (l_bfile));
   DBMS_LOB.fileopen (l_bfile);
   DBMS_OUTPUT.put_line ('Is open after open? ' || DBMS_LOB.fileisopen (l_bfile));
   DBMS_LOB.fileclose (l_bfile);
   DBMS_OUTPUT.
   put_line ('Is open after close? ' || DBMS_LOB.fileisopen (l_bfile));
END;