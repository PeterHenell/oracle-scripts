CREATE OR REPLACE DIRECTORY demo AS 'd:\demo-seminar';

DECLARE
   TYPE fgetattr_t IS RECORD (
      fexists       BOOLEAN
     ,file_length   PLS_INTEGER
     ,block_size    PLS_INTEGER
   );

   PROCEDURE bpl (val IN BOOLEAN)
   IS
   BEGIN
      IF val
      THEN
         DBMS_OUTPUT.put_line ('TRUE');
      ELSIF NOT val
      THEN
         DBMS_OUTPUT.put_line ('FALSE');
      ELSE
         DBMS_OUTPUT.put_line ('NULL');
      END IF;
   END;

   PROCEDURE check_attr (dir_in IN VARCHAR2, file_in IN VARCHAR2)
   IS
      fgetattr_rec   fgetattr_t;
   BEGIN
      UTL_FILE.fgetattr (LOCATION         => dir_in
                        ,filename         => file_in
                        ,fexists          => fgetattr_rec.fexists
                        ,file_length      => fgetattr_rec.file_length
                        ,block_size       => fgetattr_rec.block_size
                        );
      DBMS_OUTPUT.put_line (   'Checking attributes for '
                            || dir_in
                            || '\'
                            || file_in
                           );
      DBMS_OUTPUT.put_line ('fexists =');
      bpl (fgetattr_rec.fexists);
      DBMS_OUTPUT.put_line ('file length = ' || fgetattr_rec.file_length);
      DBMS_OUTPUT.put_line ('block size = ' || fgetattr_rec.block_size);
   END check_attr;
BEGIN
   check_attr ('DEMO', 'fexists2.tst');
   check_attr ('DEMO', 'fexists2.tstX');
END;
/