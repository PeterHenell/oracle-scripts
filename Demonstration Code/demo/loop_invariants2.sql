CREATE OR REPLACE TYPE plch_numbers_t IS TABLE OF NUMBER
/

CREATE OR REPLACE PROCEDURE plch_loop1 (parts_in IN plch_numbers_t)
IS
   l_result   NUMBER := 0;
BEGIN
   FOR indx IN 1 .. 10000000
   LOOP
      l_result := l_result + (parts_in (1) + parts_in (2)) / parts_in (3);
   END LOOP;

   DBMS_OUTPUT.put_line (l_result);
END;
/

CREATE OR REPLACE PROCEDURE plch_loop2 (parts_in IN plch_numbers_t)
IS
   l_computation   NUMBER := (parts_in (1) + parts_in (2)) / parts_in (3);
   l_result        NUMBER := 0;
BEGIN
   FOR indx IN 1 .. 10000000
   LOOP
      l_result := l_result + l_computation;
   END LOOP;

   DBMS_OUTPUT.put_line (l_result);
END;
/

CREATE OR REPLACE PROCEDURE plch_loop3 (parts_in IN plch_numbers_t)
IS
   l_computation   NUMBER;
   l_result        NUMBER := 0;
BEGIN
   FOR indx IN 1 .. 10000000
   LOOP
      l_computation := (parts_in (1) + parts_in (2)) / parts_in (3);
      l_result := l_result + l_computation;
   END LOOP;

   DBMS_OUTPUT.put_line (l_result);
END;
/

/* Test performance */

CREATE OR REPLACE PACKAGE plch_timer
IS
   PROCEDURE start_timer;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL);
END plch_timer;
/

CREATE OR REPLACE PACKAGE BODY plch_timer
IS
   /* Package variable which stores the last timing made */
   last_timing   NUMBER := NULL;

   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
   END;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            '"'
         || message_in
         || '" completed in: '
         || (DBMS_UTILITY.get_cpu_time - last_timing) / 100
         || ' seconds');
   END;
END plch_timer;
/

DECLARE
   l_numbers   plch_numbers_t := plch_numbers_t (4, 5, 6);
BEGIN
   plch_timer.start_timer;
   plch_loop1 (l_numbers);
   plch_timer.show_elapsed_time ('Loop1 Opt Level 2');
   --
   plch_timer.start_timer;
   plch_loop2 (l_numbers);
   plch_timer.show_elapsed_time ('Loop2 Opt Level 2');
   --
   plch_timer.start_timer;
   plch_loop3 (l_numbers);
   plch_timer.show_elapsed_time ('Loop3 Opt Level 2');
END;
/

ALTER PROCEDURE plch_loop1 COMPILE plsql_optimize_level = 1
/

DECLARE
   l_numbers   plch_numbers_t := plch_numbers_t (4, 5, 6);
BEGIN
   plch_timer.start_timer;
   plch_loop1 (l_numbers);
   plch_timer.show_elapsed_time ('Loop1 Opt Level 1');
END;
/

ALTER PROCEDURE plch_loop1 COMPILE plsql_optimize_level = 0
/

DECLARE
   l_numbers   plch_numbers_t := plch_numbers_t (4, 5, 6);
BEGIN
   plch_timer.start_timer;
   plch_loop1 (l_numbers);
   plch_timer.show_elapsed_time ('Loop1 Opt Level 0');
END;
/

/* My results on 11.2

15000000
"Loop1 Opt Level 2" completed in: .59 seconds
15000000
"Loop2 Opt Level 2" completed in: .56 seconds
15000000
"Loop3 Opt Level 2" completed in: .63 seconds
15000000
"Loop1 Opt Level 1" completed in: 2.63 seconds
15000000
"Loop1 Opt Level 0" completed in: 3.26 seconds

*/

/* Clean up */

DROP PACKAGE plch_timer
/

DROP PROCEDURE plch_loop1
/

DROP PROCEDURE plch_loop2
/

DROP PROCEDURE plch_loop3
/

DROP TYPE plch_numbers_t
/

