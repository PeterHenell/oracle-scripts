/* Formatted on 2002/01/02 15:01 (Formatter Plus v4.5.2) */
CREATE OR REPLACE DIRECTORY demodir
   AS 'd:\demo-seminar';

CREATE TABLE my_book_text (
   chapter_descr VARCHAR2(100),
   chapter_text CLOB);
   
DECLARE
   bfile1   BFILE := BFILENAME ('DEMODIR', 'login.sql');
   clob1    CLOB := EMPTY_CLOB ();
BEGIN
   insert into my_book_text values ('abc', clob1);
   
   select chapter_text into clob1 from my_book_text where rownum < 2;
    
   DBMS_LOB.fileopen (bfile1, DBMS_LOB.file_readonly);
   DBMS_LOB.loadfromfile (
      dest_lob=> clob1,
      src_lob=> bfile1,
      amount=> DBMS_LOB.getlength (bfile1)
   );
   DBMS_LOB.fileclose (bfile1);
   display_clob (clob1);
   rollback;
END;
/

/* Using temporary LOB instead of table-based LOB */

DECLARE
   bfile1   BFILE := BFILENAME ('DEMODIR', 'login.sql');
   clob1    CLOB := EMPTY_CLOB ();
BEGIN
   DBMS_LOB.CREATETEMPORARY(clob1,TRUE);
   DBMS_LOB.fileopen (bfile1, DBMS_LOB.file_readonly);
   DBMS_LOB.loadfromfile (
      dest_lob=> clob1,
      src_lob=> bfile1,
      amount=> DBMS_LOB.getlength (bfile1)
   );
   DBMS_LOB.fileclose (bfile1);
   display_clob (clob1);
   DBMS_LOB.FREETEMPORARY(clob1);
END;
/
