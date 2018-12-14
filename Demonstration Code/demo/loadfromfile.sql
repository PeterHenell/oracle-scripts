CONNECT SYS/SYS AS SYSDBA

GRANT CREATE ANY DIRECTORY TO scott
/

CONNECT SCOTT/TIGER

CREATE OR REPLACE DIRECTORY images_dir AS 'c:\temp'
/

DROP TABLE images
/

CREATE TABLE images (ID INTEGER, image BLOB)
/

DECLARE
   l_file       BFILE := BFILENAME ('IMAGES_DIR', 'steven.gif');
   l_blob_loc   BLOB  := EMPTY_BLOB ();
BEGIN
   -- Get a lob locator.
   INSERT INTO images
        VALUES (1, l_blob_loc)
     RETURNING image
          INTO l_blob_loc;

   -- Now load the file into that lob locator
   DBMS_LOB.fileopen (l_file, DBMS_LOB.file_readonly);
   DBMS_LOB.loadfromfile (dest_lob      => l_blob_loc
                        , src_lob       => l_file
                        , amount        => DBMS_LOB.getlength (l_file)
                         );
   DBMS_LOB.fileclose (l_file);
   COMMIT;
END;
/

SELECT COUNT(*) FROM images
/
