/* Open file for write */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid :=
      UTL_FILE.fopen ('TEMP'
                    , 'demo.txt'
                    , 'W'
                    , max_linesize   => 32767);
   UTL_FILE.fclose (fid);
END;
/

/* Open file for write/specifying max line size too large */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid :=
      UTL_FILE.fopen ('TEMP'
                    , 'demo.txt'
                    , 'W'
                    , max_linesize   => 32768);
   UTL_FILE.fclose (fid);
END;
/

/* Trap invalid linesize error */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid :=
      UTL_FILE.fopen ('TEMP'
                    , 'demo.txt'
                    , 'W'
                    , max_linesize   => 32768);
   UTL_FILE.fclose (fid);
EXCEPTION
   WHEN UTL_FILE.invalid_maxlinesize
   THEN
      DBMS_OUTPUT.put_line ('Line size invalid!');
END;
/

/* Open file for read */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid :=
      UTL_FILE.fopen ('TEMP'
                    , 'demo.txt'
                    , 'R'
                    , max_linesize   => 32767);
   UTL_FILE.fclose (fid);
END;
/

/* Try to open file that does not exist */

DECLARE
   fid   UTL_FILE.file_type;
BEGIN
   fid :=
      UTL_FILE.fopen ('TEMP'
                    , 'not a file on my computer.txt'
                    , 'R'
                    , max_linesize   => 32767);
   UTL_FILE.fclose (fid);
EXCEPTION
   WHEN UTL_FILE.invalid_operation
   THEN
      DBMS_OUTPUT.put_line ('Invalid File Operation - file does not exist!');
END;
/