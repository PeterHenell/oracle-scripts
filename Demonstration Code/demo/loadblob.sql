/* Demo the loading of a file into a BLOB using only PL/SQL
*/
SET ECHO OFF
SET FEEDBACK OFF
DROP TABLE web_graphic_blobs;
SET ECHO ON FEEDBACK ON

CREATE TABLE web_graphic_blobs (image_id INTEGER, image BLOB);

PAUSE

CREATE OR REPLACE DIRECTORY web_pix
   AS 'f:\photos\family';

PAUSE

DECLARE
   pic_file BFILE := BFILENAME('WEB_PIX', 'veva-silva-aaa2.jpg');
   pic_blob_loc BLOB := EMPTY_BLOB();

BEGIN
   INSERT INTO web_graphic_blobs
      VALUES (1, pic_blob_loc)
      RETURNING image INTO pic_blob_loc;

   DBMS_LOB.FILEOPEN(pic_file, DBMS_LOB.FILE_READONLY);

   DBMS_LOB.LOADFROMFILE(dest_lob => pic_blob_loc,
      src_lob => pic_file,
      amount => DBMS_LOB.GETLENGTH(pic_file));

   DBMS_LOB.FILECLOSE(pic_file);
END;
/


REM  Copyright (c) 1999 DataCraft, Inc. and William L. Pribyl
REM  All Rights Reserved
