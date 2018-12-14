CREATE OR REPLACE PROCEDURE get_nextline (
   file_in IN UTL_FILE.file_type
 , line_out OUT VARCHAR2
 , eof_out OUT BOOLEAN
)
IS
BEGIN
   UTL_FILE.get_line (file_in, line_out);
   eof_out := FALSE;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      line_out := NULL;
      eof_out := TRUE;
/*
   WHEN OTHERS
   THEN
      q$error_manager.raise_unanticipated
                                      (text_in        => 'Unable to deal with file'
                                     , name1_in       => 'FILE ID'
                                     , value1_in      => file_in.ID
                                      );
*/
END;
/