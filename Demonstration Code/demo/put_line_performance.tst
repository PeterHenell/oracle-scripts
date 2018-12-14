/*
Note: you will need to compile the sf_timer package for this script to 
run without errors. 

@sf_timer.pks
@sf_timer.pkb
*/

DECLARE
   l_file   UTL_FILE.file_type;
   l_line   VARCHAR2 (32767);
BEGIN
   sf_timer.start_timer;
   l_file :=
      UTL_FILE.fopen ('TEMP', 'newstuff.txt', 'W', max_linesize => 32767);

   FOR indx_o IN 1 .. 300000
   LOOP
      UTL_FILE.put_line (l_file, RPAD ('abc', 100, 'x'));
   END LOOP;

   UTL_FILE.fclose (l_file);
   sf_timer.show_elapsed_time ('300000 putlines of 100 characters');

   sf_timer.start_timer;
   l_file :=
      UTL_FILE.fopen ('TEMP', 'newstuff.txt', 'W', max_linesize => 32767);

   FOR indx_o IN 1 .. 1000
   LOOP
      l_line := NULL;

      FOR indx IN 1 .. 300
      LOOP
         l_line := l_line || CHR (10) || RPAD ('abc', 100, 'x');
      END LOOP;

      UTL_FILE.put_line (l_file, l_line);
   END LOOP;

   sf_timer.show_elapsed_time ('1000 putlines of 30000 characters');
/*
11.1
300 putlines of 100 each - Elapsed CPU : 5.57 seconds.
1 putlines of 30000 - Elapsed CPU : 2.25 seconds.
*/
END;
/

/*
Verify degradation of performance with autoflush set to true.
*/

DECLARE
   l_file   UTL_FILE.file_type;
   l_line   VARCHAR2 (32767);
BEGIN
   sf_timer.start_timer;
   l_file :=
      UTL_FILE.fopen ('TEMP', 'newstuff.txt', 'W', max_linesize => 32767);

   FOR indx_o IN 1 .. 3000
   LOOP
      UTL_FILE.put_line (l_file, RPAD ('abc', 100, 'x'));
   END LOOP;

   UTL_FILE.fclose (l_file);
   sf_timer.show_elapsed_time ('3000 putlines with autoflush set to FALSE');

   sf_timer.start_timer;
   l_file :=
      UTL_FILE.fopen ('TEMP', 'newstuff.txt', 'W', max_linesize => 32767);

   FOR indx_o IN 1 .. 3000
   LOOP
      UTL_FILE.put_line (l_file, RPAD ('abc', 100, 'x'), autoflush => TRUE);
   END LOOP;

   UTL_FILE.fclose (l_file);
   sf_timer.show_elapsed_time ('3000 putlines with autoflush set to TRUE');
/*
3000 putlines with autoflush set to FALSE - Elapsed CPU : .15 seconds.
3000 putlines with autoflush set to TRUE - Elapsed CPU : 1.84 seconds.
*/
END;
/

CREATE OR REPLACE PROCEDURE put_each_line (
   file_inout IN UTL_FILE.file_type
 , file_contents_in IN DBMS_SQL.varchar2a
)
IS
BEGIN
   FOR indx IN 1 .. file_contents_in.COUNT
   LOOP
      UTL_FILE.put_line (file_inout, file_contents_in (indx));
   END LOOP;

   UTL_FILE.fclose (file_inout);
END put_each_line;
/

/* Here's a utility that automatically combines multiple
   lines for consolidated "put" to file operations. */

CREATE OR REPLACE PROCEDURE put_each_line (
   file_inout IN OUT UTL_FILE.file_type
 , file_contents_in IN DBMS_SQL.varchar2a
)
IS
   c_newline   CONSTANT CHAR (1) := CHR (10);
   l_line      VARCHAR2 (32767);
   l_index     PLS_INTEGER := file_contents_in.FIRST;

   PROCEDURE combine_lines (file_contents_in IN DBMS_SQL.varchar2a
                          , index_inout IN OUT PLS_INTEGER
                          , line_out   OUT VARCHAR2
                           )
   IS
      l_combined_line   VARCHAR2 (32767);
   BEGIN
      LOOP
         BEGIN
            l_combined_line :=
               l_combined_line
               || CASE
                     WHEN l_combined_line IS NULL THEN NULL
                     ELSE c_newline
                  END
               || file_contents_in (index_inout);
            index_inout := index_inout + 1;
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               /* Can't fit this last string, so don't increment counter.
                  Just set the OUT argument with this combined string. */
               line_out := l_combined_line;
               EXIT;
            WHEN NO_DATA_FOUND
            THEN
               /* Have finished reading through contents of array.
                  Terminate the loop by setting the index value to NULL. */
               index_inout := NULL;
               line_out := l_combined_line;
               EXIT;
         END;
      END LOOP;
   END combine_lines;
BEGIN
   WHILE l_index IS NOT NULL
   LOOP
      combine_lines (file_contents_in, l_index, l_line);

      UTL_FILE.put_line (file_inout, l_line);
   END LOOP;

   UTL_FILE.fclose (file_inout);
END put_each_line;
/

DECLARE
   l_file    UTL_FILE.file_type;

   l_lines   DBMS_SQL.varchar2a;
BEGIN
   l_file := UTL_FILE.fopen ('TEMP', 'bignews.txt', 'W');
   l_lines (1) := 'Barack';
   l_lines (2) := 'Obama';
   l_lines (3) := 'is';
   l_lines (4) := 'President';
   put_each_line (l_file, l_lines);
END;
/