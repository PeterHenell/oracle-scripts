CREATE OR REPLACE DIRECTORY plch_temp AS 'c:\temp'
/

CREATE OR REPLACE FUNCTION flength (
   location_in   IN VARCHAR2
 ,  file_in       IN VARCHAR2)
   RETURN PLS_INTEGER
IS
   TYPE fgetattr_t IS RECORD
   (
      fexists       BOOLEAN
    ,  file_length   PLS_INTEGER
    ,  block_size    PLS_INTEGER
   );

   fgetattr_rec   fgetattr_t;
BEGIN
   UTL_FILE.fgetattr (
      location      => location_in
    ,  filename      => file_in
    ,  fexists       => fgetattr_rec.fexists
    ,  file_length   => fgetattr_rec.file_length
    ,  block_size    => fgetattr_rec.block_size);
   RETURN fgetattr_rec.file_length;
END flength;
/

BEGIN
   DBMS_OUTPUT.put_line (
      'Length=' || flength ('PLCH_TEMP', 'test.txt'));
   DBMS_OUTPUT.put_line (
      'Length=' || flength ('PLCH_TEMP', 'nothere.txt'));
END;
/

/* And then there is DBMS_LOB.GETLENGTH */

DECLARE
   l_bfile   BFILE := BFILENAME ('PLCH_TEMP', 'test.txt');
BEGIN
   DBMS_OUTPUT.put_line (
      'Length=' || DBMS_LOB.getlength (l_bfile));
END;
/
