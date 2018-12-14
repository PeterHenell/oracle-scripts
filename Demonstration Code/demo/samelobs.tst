/* Formatted on 2001/11/21 14:36 (Formatter Plus v4.5.2) */
CREATE OR REPLACE DIRECTORY demodir
   AS 'd:\demo-seminar';

create or replace procedure samelobs_test
is
   bfile1   BFILE := BFILENAME ('DEMODIR', 'login.sql');
   clob1    CLOB  := EMPTY_CLOB ();
   clob2    CLOB  := EMPTY_CLOB ();

   PROCEDURE load_file (lob_inout IN OUT CLOB)
   IS
   BEGIN
      DBMS_LOB.fileopen (bfile1, DBMS_LOB.file_readonly);
      DBMS_LOB.loadfromfile (
         dest_lob=> lob_inout,
         src_lob=> bfile1,
         amount=> DBMS_LOB.getlength (bfile1)
      );
      DBMS_LOB.fileclose (bfile1);
   END;
BEGIN
   load_file (clob1);
   load_file (clob2);
   p.l (samelobs (clob1, clob2));
END;
/

