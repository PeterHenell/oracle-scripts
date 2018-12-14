DECLARE
   PROCEDURE showline1 (file IN VARCHAR2)
   IS
      fid UTL_FILE.file_type;
      v_line VARCHAR2 (2000);
   BEGIN
      DBMS_OUTPUT.put_line (
         'First line of ' || file || ':');
      fid := fileio.open (file);
      UTL_FILE.get_line (fid, v_line);
      DBMS_OUTPUT.put_line ('   ' || v_line);
      UTL_FILE.fclose (fid);
      DBMS_OUTPUT.put_line (' ');
   END;
BEGIN
   fileio.setpath (
      'c:\temp;d:\demo-seminar;d:\openoracle\utplsql\code'
   );
   showline1 ('filepath.pkg');
   showline1 ('utplsql.pkb');
END;
/
