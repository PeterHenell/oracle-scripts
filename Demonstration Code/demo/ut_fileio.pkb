CREATE OR REPLACE PACKAGE BODY ut_fileio
IS
   PROCEDURE setup
   IS
   BEGIN
      -- For each program to test...
      utPLSQL.addtest ('OPEN');
   END;
   
   PROCEDURE teardown
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE OPEN 
   IS
      FUNCTION line1_without_path (loc IN VARCHAR2, file IN VARCHAR2) RETURN VARCHAR2
      IS
         fid UTL_FILE.file_type;
         v_line VARCHAR2 (2000);
      BEGIN
         fid := UTL_FILE.FOPEN (loc, file, 'R');
         UTL_FILE.get_line (fid, v_line);
         UTL_FILE.fclose (fid);
         RETURN v_line;
      END;

      FUNCTION line1_with_path (file IN VARCHAR2) RETURN VARCHAR2
      IS
         fid UTL_FILE.file_type;
         v_line VARCHAR2 (2000);
      BEGIN
         fid := fileio.open (file);
         UTL_FILE.get_line (fid, v_line);
         UTL_FILE.fclose (fid);
         RETURN v_line;
      END;
   BEGIN
      fileio.setpath (
         'c:\temp;e:\demo;e:\openoracle\utplsql\code'
      );

      utAssert.eq (
         'Test of OPEN',
         line1_with_path ('filepath.pkg'),
         line1_without_path ('e:\demo', 'filepath.pkg')
         );

      utAssert.eq (
         'Test of OPEN',
         line1_with_path ('utplsql.pkb'),
         line1_without_path ('e:\openoracle\utplsql\code', 'utplsql.pkb')
         );
   END OPEN;
END ut_fileio;
/
