CREATE OR REPLACE FUNCTION fexists (
   dir_in IN VARCHAR2
 , file_in IN VARCHAR2
)
   RETURN BOOLEAN
/*
Name of program: fexists

Summary: Uses UTL_FILE.FGETATTR to determine if a file exists.

         Includes workaround for bug #4547551:
            UTL_FILE fexists return NULL for a non-existent file
            while file_length and block_size are both set to 0.

Author: Steven Feuerstein
*/
IS
   l_fexists BOOLEAN;
   l_file_length PLS_INTEGER;
   l_block_size PLS_INTEGER;
BEGIN
   UTL_FILE.fgetattr ( LOCATION         => dir_in
                     , filename         => file_in
                     , fexists          => l_fexists
                     , file_length      => l_file_length
                     , block_size       => l_block_size
                     );

   -- When bug is fixed...
   -- REMOVE FROM HERE
   IF l_fexists IS NULL AND l_file_length = 0 AND l_block_size = 0
   THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;
   -- TO HERE
   /* Then uncomment the following line of code: */
   --RETURN l_fexists;
END fexists;
/

