CREATE OR REPLACE TYPE plch_strings_t
   IS TABLE OF VARCHAR2 (100)
/

CREATE OR REPLACE PROCEDURE plch_test_set (
   test_size IN NUMBER)
IS
   strings_table   plch_strings_t := plch_strings_t ();
BEGIN
   strings_table.EXTEND (test_size);

   FOR indx IN 1 .. test_size
   LOOP
      strings_table (indx) := indx;
   END LOOP;

   strings_table := SET (strings_table);
END;
/

CREATE OR REPLACE PROCEDURE plch_test_distinct (
   test_size IN NUMBER)
IS
   strings_table   plch_strings_t := plch_strings_t ();
BEGIN
   strings_table.EXTEND (test_size);

   FOR indx IN 1 .. test_size
   LOOP
      strings_table (indx) := indx;
   END LOOP;

   SELECT DISTINCT *
     BULK COLLECT INTO strings_table
     FROM (SELECT * FROM TABLE (strings_table));
END;
/

SET SERVEROUTPUT ON

DECLARE
   last_timing   NUMBER := NULL;

   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
   END;

   PROCEDURE show_elapsed_time (
      message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            '"'
         || message_in
         || '" completed in: '
         || (DBMS_UTILITY.get_cpu_time - last_timing) / 100
         || ' seconds');
      start_timer;
   END;
BEGIN
   start_timer;
   plch_test_set (1000);
   show_elapsed_time ('SET 1000');
   plch_test_distinct (1000);
   show_elapsed_time ('DISTINCT 1000');
   plch_test_set (10000);
   show_elapsed_time ('SET 10000');
   plch_test_distinct (10000);
   show_elapsed_time ('DISTINCT 10000');
   plch_test_set (100000);
   show_elapsed_time ('SET 100000');
   plch_test_distinct (100000);
   show_elapsed_time ('DISTINCT 100000');
END;
/

DROP PROCEDURE plch_test_set
/

DROP PROCEDURE plch_test_distinct
/

DROP TYPE plch_strings_t
/