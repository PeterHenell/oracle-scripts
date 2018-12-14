CREATE OR REPLACE PROCEDURE xml_to_file (
   newcontext_qry   VARCHAR2
 , rowsettag        VARCHAR2
 , rowtag           VARCHAR2
 , filename         VARCHAR2
)
IS
-- Input query string

-- Input rowsetTag , the root tag
-- Input row level tag
-- Input file name
BEGIN
   DECLARE
      qryctx        DBMS_XMLGEN.ctxhandle;
      RESULT        CLOB;
      lob_length    INTEGER;
      read_amount   INTEGER;
      read_offset   INTEGER;
      buffer        VARCHAR2 (100);
      loc           VARCHAR2 (100)        := 'usr_dir';
      f_hand        UTL_FILE.file_type;
   BEGIN
      -- Setting up offset and no. of chars to be read in
      -- in one go from clob datatype.
      read_offset := 1;
      read_amount := 75;
      DBMS_OUTPUT.put_line ('opening');
      --Opening file
      f_hand :=
         UTL_FILE.fopen (LOCATION          => 'TEMP'
                       , filename          => filename
                       , open_mode         => 'w'
                       , max_linesize      => 32767
                        );
      DBMS_OUTPUT.put_line ('file open');
      -- Creating new context
      qryctx := DBMS_XMLGEN.newcontext (newcontext_qry);
      -- Defining Rowsettag
      DBMS_XMLGEN.setrowsettag (qryctx, rowsettag);
      -- Defining Rowtag
      DBMS_XMLGEN.setrowtag (qryctx, rowtag);
      -- Generating XML and storing in an clob datatype
      RESULT := DBMS_XMLGEN.getxml (qryctx);
      DBMS_OUTPUT.put_line ('xml generated');
      -- Getting the length of the data stored in Clob
      lob_length := DBMS_LOB.getlength (RESULT);

      -- Reading data from clob variable and writng into file.
      WHILE (lob_length > 0)
      LOOP
         DBMS_LOB.READ (RESULT, read_amount, read_offset, buffer);
         DBMS_OUTPUT.put_line ('writing in file');
         UTL_FILE.put (f_hand, buffer);
         DBMS_OUTPUT.put_line ('written');
         read_offset := read_offset + read_amount;
         lob_length := lob_length - read_amount;

         IF lob_length < read_amount
         THEN
            read_amount := lob_length;
         END IF;
      END LOOP;

      UTL_FILE.fclose (f_hand);
   EXCEPTION
      WHEN UTL_FILE.invalid_path
      THEN
         raise_application_error (-20100, 'Invalid Path');
      WHEN UTL_FILE.invalid_mode
      THEN
         raise_application_error (-20101, 'Invalid Mode');
      WHEN UTL_FILE.invalid_operation
      THEN
         raise_application_error (-20102, 'Invalid Operation');
      WHEN UTL_FILE.invalid_filehandle
      THEN
         raise_application_error (-20103, 'Invalid Filehandle');
      WHEN UTL_FILE.write_error
      THEN
         raise_application_error (-20104, 'Write Error');
      WHEN UTL_FILE.read_error
      THEN
         raise_application_error (-20105, 'Read Error');
      WHEN UTL_FILE.internal_error
      THEN
         raise_application_error (-20106, 'Internal Error');
      WHEN OTHERS
      THEN
         UTL_FILE.fclose (f_hand);
   END;
END xml_to_file;
/