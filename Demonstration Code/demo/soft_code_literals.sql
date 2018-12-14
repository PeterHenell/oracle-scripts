DROP TABLE magic_values
/

CREATE TABLE magic_values
(
   name          VARCHAR2 (1000),
   identifier    VARCHAR2 (30),
   magic_value   VARCHAR2 (1000),
   datatype      VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO magic_values
        VALUES ('Maximum Salary',
                'max_salary',
                10000000,
                'NUMBER');

   INSERT INTO magic_values
        VALUES ('Company Name',
                'company_name',
                'Oracle Corporation',
                'VARCHAR2');

   INSERT INTO magic_values
        VALUES ('Earliest Date',
                'earliest_date',
                '2000-10-11 12:10:00',
                'DATE');

   COMMIT;
END;
/

CREATE OR REPLACE FUNCTION magic_value_for (NAME_IN IN VARCHAR2)
   RETURN VARCHAR2
   DETERMINISTIC
   RESULT_CACHE
IS
   l_return   magic_values.magic_value%TYPE;
BEGIN
   SELECT magic_value
     INTO l_return
     FROM magic_values mv
    WHERE mv.name = NAME_IN;

   RETURN l_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
END magic_value_for;
/

CREATE OR REPLACE PROCEDURE gen_magic_values_pkg (
   NAME_IN        IN VARCHAR2 DEFAULT 'magic_values_mgr',
   to_file_in     IN BOOLEAN DEFAULT FALSE,
   dir_in         IN VARCHAR2 DEFAULT 'DEMO',
   ext_in         IN VARCHAR2 DEFAULT 'pkg',
   date_mask_in   IN VARCHAR2 DEFAULT 'YYYY-MM-DD HH24:MI:SS')
IS
   c_to_screen   CONSTANT BOOLEAN := NVL (NOT to_file_in, TRUE);
   c_file        CONSTANT VARCHAR2 (1000)
                             := NAME_IN || '.' || ext_in ;

   /*
   Array of output for package. First I fill up the array,
   then I dump it out to the requested location (screen or file).
   */
   TYPE lines_t IS TABLE OF VARCHAR2 (1000)
      INDEX BY PLS_INTEGER;

   output                 lines_t;

   PROCEDURE add_to_output (str IN VARCHAR2)
   IS
   BEGIN
      output (output.COUNT + 1) := str;
   END;

   PROCEDURE dump_output
   IS
   BEGIN
      IF c_to_screen
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
            fid := UTL_FILE.fopen (dir_in, c_file, 'W');

            FOR indx IN output.FIRST .. output.LAST
            LOOP
               UTL_FILE.put_line (fid, output (indx));
            END LOOP;

            UTL_FILE.fclose (fid);
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                     'Failure to write output to '
                  || dir_in
                  || '/'
                  || c_file);
               UTL_FILE.fclose (fid);
         END;
      END IF;
   END dump_output;
BEGIN
   add_to_output ('CREATE OR REPLACE PACKAGE ' || NAME_IN);
   add_to_output ('IS ');

   FOR mv_rec IN (  SELECT *
                      FROM magic_values
                  ORDER BY name)
   LOOP
      add_to_output (
            '   FUNCTION '
         || mv_rec.identifier
         || ' RETURN '
         || mv_rec.datatype
         || ' DETERMINISTIC RESULT_CACHE;');
   END LOOP;

   add_to_output ('END ' || NAME_IN || ';');
   add_to_output ('/');


   add_to_output ('CREATE OR REPLACE PACKAGE BODY ' || NAME_IN);
   add_to_output ('IS ');

   FOR mv_rec IN (  SELECT *
                      FROM magic_values
                  ORDER BY name)
   LOOP
      add_to_output (
            '   FUNCTION '
         || mv_rec.identifier
         || ' RETURN '
         || mv_rec.datatype
         || ' RESULT_CACHE');

      add_to_output (
            '   IS BEGIN RETURN '
         || CASE mv_rec.datatype
               WHEN 'VARCHAR2'
               THEN
                  '''' || mv_rec.magic_value || ''''
               WHEN 'NUMBER'
               THEN
                  mv_rec.magic_value
               WHEN 'DATE'
               THEN
                     'TO_DATE ('
                  || ''''
                  || mv_rec.magic_value
                  || ''', '''
                  || date_mask_in
                  || ''')'
            END
         || '; END;');
      add_to_output ('   ');
   END LOOP;

   add_to_output ('END ' || NAME_IN || ';');
   add_to_output ('/');

   dump_output;
END gen_magic_values_pkg;
/

BEGIN
   gen_magic_values_pkg ();
END;
/

/* Generated package 

CREATE OR REPLACE PACKAGE magic_values_mgr
IS 
   FUNCTION company_name RETURN VARCHAR2 DETERMINISTIC RESULT_CACHE;
   FUNCTION earliest_date RETURN DATE DETERMINISTIC RESULT_CACHE;
   FUNCTION max_salary RETURN NUMBER DETERMINISTIC RESULT_CACHE;
END magic_values_mgr;
/
CREATE OR REPLACE PACKAGE BODY magic_values_mgr
IS 
   FUNCTION company_name RETURN VARCHAR2 RESULT_CACHE
   IS BEGIN RETURN 'Oracle Corporation'; END;
   
   FUNCTION earliest_date RETURN DATE RESULT_CACHE
   IS BEGIN RETURN TO_DATE ('2000-10-11 12:10:00', 'YYYY-MM-DD HH24:MI:SS'); END;
   
   FUNCTION max_salary RETURN NUMBER RESULT_CACHE
   IS BEGIN RETURN 10000000; END;
   
END magic_values_mgr;
/

*/