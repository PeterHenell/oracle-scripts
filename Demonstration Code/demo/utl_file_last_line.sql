/*

To run this script without any errors, you will need two priviliegse:

CREATE ANY DIRECTORY 
DROP ANY DIRECTORY 

You will also need to change the directory location and make
sure the file is created.

*/
CREATE OR REPLACE DIRECTORY plch_temp AS 'c:/temp';
/

/* Read to the nth line sequentially */

CREATE OR REPLACE FUNCTION plch_nth_line (
   location_in   IN VARCHAR2,
   file_in       IN VARCHAR2,
   nth_line_in   IN INTEGER)
   RETURN VARCHAR2
IS
   l_file   UTL_FILE.file_type;
   l_text   VARCHAR2 (32767);
BEGIN
   l_file :=
      UTL_FILE.fopen (location_in,
                      file_in,
                      'r',
                      32767);

   FOR indx IN 1 .. nth_line_in
   LOOP
      UTL_FILE.get_line (l_file, l_text);
   END LOOP;

   UTL_FILE.fclose (l_file);
   RETURN l_text;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_nth_line ('PLCH_TEMP', 'temp.txt', 2));
END;
/

/* Incorrect usage of get_line */

CREATE OR REPLACE FUNCTION plch_nth_line (
   location_in   IN VARCHAR2,
   file_in       IN VARCHAR2,
   nth_line_in   IN INTEGER)
   RETURN VARCHAR2
IS
   l_file   UTL_FILE.file_type;
   l_text   VARCHAR2 (32767);
BEGIN
   l_file :=
      UTL_FILE.fopen (location_in,
                      file_in,
                      'r',
                      32767);

   UTL_FILE.get_line (l_file, l_text, nth_line_in);

   UTL_FILE.fclose (l_file);
   RETURN l_text;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_nth_line ('PLCH_TEMP', 'temp.txt', 2));
END;
/

/* Seek out the line by position */

CREATE OR REPLACE FUNCTION plch_nth_line (
   location_in   IN VARCHAR2,
   file_in       IN VARCHAR2,
   nth_line_in   IN INTEGER)
   RETURN VARCHAR2
IS
   c_line_length   CONSTANT PLS_INTEGER := 5;
   l_file                   UTL_FILE.file_type;
   l_text                   VARCHAR2 (32767);
BEGIN
   l_file :=
      UTL_FILE.fopen (location_in,
                      file_in,
                      'r',
                      32767);

   UTL_FILE.fseek (l_file,
                   c_line_length * (nth_line_in - 1) + 1);

   UTL_FILE.get_line (l_file, l_text);

   UTL_FILE.fclose (l_file);
   
   RETURN l_text;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_nth_line ('PLCH_TEMP', 'temp.txt', 2));
END;
/

/* Ah, if only...there is no function with this name. */

CREATE OR REPLACE FUNCTION plch_nth_line (
   location_in   IN VARCHAR2,
   file_in       IN VARCHAR2,
   nth_line_in   IN INTEGER)
   RETURN VARCHAR2
IS
BEGIN
   RETURN UTL_FILE.nth_line (location_in,
                             file_in,
                             nth_line_in);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      plch_nth_line ('PLCH_TEMP', 'temp.txt', 2));
END;
/



/* Clean up */

DROP FUNCTION plch_nth_line
/

DROP DIRECTORY temp
/