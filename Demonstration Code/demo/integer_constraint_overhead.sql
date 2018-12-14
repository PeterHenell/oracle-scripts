CREATE OR REPLACE PROCEDURE test_integer_varieties (
   iterations_in   IN   PLS_INTEGER DEFAULT 1
)
IS
   l_integer       INTEGER;
   l_bin_integer   BINARY_INTEGER;
   l_pls_integer   PLS_INTEGER;
   l_positive      POSITIVE;
BEGIN
   sf_timer.start_timer;

   FOR indx IN 1 .. iterations_in
   LOOP
      l_integer := 100000000;
   END LOOP;

   sf_timer.show_elapsed_time ('Integer');
   --
   sf_timer.start_timer;

   FOR indx IN 1 .. iterations_in
   LOOP
      l_pls_integer := 100000000;
   END LOOP;

   sf_timer.show_elapsed_time ('PLS_Integer');
   --
   sf_timer.start_timer;

   FOR indx IN 1 .. iterations_in
   LOOP
      l_bin_integer := 100000000;
   END LOOP;

   sf_timer.show_elapsed_time ('BINARY_Integer');
   --
   sf_timer.start_timer;

   FOR indx IN 1 .. iterations_in
   LOOP
      l_positive := 100000000;
   END LOOP;

   sf_timer.show_elapsed_time ('Positive by Type');
   --
   sf_timer.start_timer;

   FOR indx IN 1 .. iterations_in
   LOOP
      IF 100000000 > 0
      THEN
         l_pls_integer := 100000000;
      ELSE
         RAISE VALUE_ERROR;
      END IF;
   END LOOP;

   sf_timer.show_elapsed_time ('Positive by Coding');
END test_integer_varieties;
/

BEGIN
   test_integer_varieties (1000000);
/*
Integer Elapsed: 8.58 seconds.
PLS_Integer Elapsed: 1.72 seconds.
Positive Elapsed: 3.03 seconds.
*/
END;
/