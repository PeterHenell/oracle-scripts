CREATE OR REPLACE DIRECTORY temp AS 'c:/temp';
/

/* File contains

line1
line2
*/

DECLARE
   l_file          UTL_FILE.file_type;
   l_location      VARCHAR2 (100) := 'TEMP';
   l_filename      VARCHAR2 (100) := 'temp.txt';
   l_exists        BOOLEAN;
   l_file_length   NUMBER;
   l_blocksize     NUMBER;
   l_text          VARCHAR2 (32767);
BEGIN
   UTL_FILE.fgetattr (l_location,
                      l_filename,
                      l_exists,
                      l_file_length,
                      l_blocksize);

   -- Open file.
   l_file :=
      UTL_FILE.fopen (l_location,
                      l_filename,
                      'r',
                      32767);

   DBMS_OUTPUT.put_line ('File length: ' || l_file_length);

   /* Show each character from back to front */
   FOR indx IN REVERSE 0 .. l_file_length
   LOOP
      DBMS_OUTPUT.put_line ('FSEEK to: ' || TO_CHAR (indx)); -- l_file_length - indx + 1));
      UTL_FILE.fseek (l_file, indx); -- l_file_length - indx + 1);

      /* Get a single character */
      UTL_FILE.get_line (l_file, l_text, 1);

      IF l_text IS NULL
      THEN
         DBMS_OUTPUT.put_line ('End of line');
      ELSE
         DBMS_OUTPUT.put_line (
               indx
            || '-char-ASCII: '
            || UTL_FILE.fgetpos (l_file)
            || '-'
            || l_text
            || '-'
            || ASCII (l_text));
      END IF;
   END LOOP;

   UTL_FILE.fclose (l_file);
END;
/

/* Clean up */

DROP DIRECTORY temp
/