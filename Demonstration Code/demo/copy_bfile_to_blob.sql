CREATE OR REPLACE PROCEDURE openfile

/*
Written by Finn Ellebaek Nielsen <ellebaek@ellebaek-consulting.com>
correcting buggy question in Kaplan's SelfTest.
*/

AS
   file1         BFILE;
   filelob       BLOB;
   b1            BLOB;
   dest_offset   INTEGER := 1;
   src_offset    INTEGER := 1;
BEGIN
   file1 := BFILENAME ('dir1', 'logo.jpg');

   DBMS_LOB.fileopen (file1, DBMS_LOB.file_readonly);

   IF (DBMS_LOB.fileexists (file1) = 1)
   THEN
      DBMS_LOB.loadblobfromfile (filelob
                               ,  file1
                               ,  DBMS_LOB.lobmaxsize
                               ,  dest_offset
                               ,  src_offset);

      DBMS_LOB.fileopen (filelob, DBMS_LOB.lob_readwrite);

      DBMS_LOB.COPY (b1
                   ,  filelob
                   ,  DBMS_LOB.lobmaxsize
                   ,  1
                   ,  1);

      DBMS_LOB.close (filelob);

      DBMS_LOB.close (b1);
   END IF;

   DBMS_LOB.fileclose (file1);
END;
/