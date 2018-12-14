CREATE OR REPLACE PROCEDURE <name> (
   ,to_file_in    IN   BOOLEAN := TRUE
   ,file_in       IN   VARCHAR2 := NULL
   ,dir_in        IN   VARCHAR2 := 'DEMO' -- Oracle9i R2 directory
   ,ext_in        IN   VARCHAR2 := 'pkg'
)
/* 
Fragment of code you can use to easily offer toggled output to screen or 
file. Call pl instead of dbms_output.put_line and then at the end of
your program's execution, call dump_output to flush the output to your
selected target.
*/
IS 
   -- Send output to file or screen?
   v_to_screen    BOOLEAN      := NVL (NOT to_file_in, TRUE);
   v_file VARCHAR2(1000) := file_in || '.' || ext_in;
   
   -- Array of output for package
   TYPE lines_t IS TABLE OF VARCHAR2 (1000)
      INDEX BY BINARY_INTEGER;

   output         lines_t;

   -- Now pl simply writes to the array.
   PROCEDURE pl (str IN VARCHAR2)
   IS
   BEGIN
      output (NVL (output.LAST, 0) + 1) := str;
   END;
   
   -- Dump to screen or file.
   PROCEDURE dump_output
   IS
   BEGIN
      IF v_to_screen
      THEN
         FOR indx IN output.FIRST .. output.LAST
         LOOP
            DBMS_OUTPUT.put_line (output (indx));
         END LOOP;
      ELSE
         -- Send output to the specified file.
         DECLARE
            fid   UTL_FILE.file_type;
         BEGIN
            fid := UTL_FILE.fopen (dir_in, v_file, 'W');

            FOR indx IN output.FIRST .. output.LAST
            LOOP
               UTL_FILE.put_line (fid, output (indx));
            END LOOP;

            UTL_FILE.fclose (fid);
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  'Failure to write output to ' || dir_in || '/' || v_file
               );
               UTL_FILE.fclose (fid);
         END;
      END IF;
   END dump_output;
BEGIN
   --
   dump_output;
END;
