DECLARE
   TYPE fgetattr_t IS RECORD (
      fexists BOOLEAN
    , file_length PLS_INTEGER
    , block_size PLS_INTEGER
   );

   FUNCTION fexists (
      dir_in IN VARCHAR2
    , file_in IN VARCHAR2
   )
      RETURN BOOLEAN
   IS
      fgetattr_rec fgetattr_t;
   BEGIN
      UTL_FILE.fgetattr ( LOCATION         => dir_in
                        , filename         => file_in
                        , fexists          => fgetattr_rec.fexists
                        , file_length      => fgetattr_rec.file_length
                        , block_size       => fgetattr_rec.block_size
                        );
      RETURN fgetattr_rec.fexists;
   END;
BEGIN
   -- This file exists....
   IF fexists ( 'TEMP', 'temp.sql' ) then 
   -- Non-existent file
   qd_runtime.pl ( fexists ( 'TEMP', 'tempxxxx.sql' ));
END;
