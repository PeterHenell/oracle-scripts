/*

IS A SET is SLOOOOOOW for larger sets.

"TABLE OPERATOR - Distinct for 100 elements" completed in: 0 seconds
"IS NOT A SET - Distinct for 100 elements" completed in: .02 seconds
"TABLE OPERATOR - Not Distinct for 100 elements" completed in: .01 seconds
"IS NOT A SET - Not Distinct for 100 elements" completed in: .02 seconds

"TABLE OPERATOR - Distinct for 10000 elements" completed in: .03 seconds
"IS NOT A SET - Distinct for 10000 elements" completed in: 15.89 seconds
"TABLE OPERATOR - Not Distinct for 10000 elements" completed in: .05 seconds
"IS NOT A SET - Not Distinct for 10000 elements" completed in: 15.8 seconds

*/

CREATE OR REPLACE TYPE plch_numbers_nt IS TABLE OF NUMBER;
/

CREATE OR REPLACE PACKAGE plch_pkg
IS
   FUNCTION has_dups_table_op (array_in IN plch_numbers_nt)
      RETURN BOOLEAN;

   FUNCTION has_dups_is_not_a_set (array_in IN plch_numbers_nt)
      RETURN BOOLEAN;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   FUNCTION has_dups_table_op (array_in IN plch_numbers_nt)
      RETURN BOOLEAN
   IS
      l_count   PLS_INTEGER;
   BEGIN
      SELECT COUNT (DISTINCT COLUMN_VALUE)
        INTO l_count
        FROM TABLE (array_in);

      RETURN l_count < array_in.COUNT;
   END;

   FUNCTION has_dups_is_not_a_set (array_in IN plch_numbers_nt)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN array_in IS NOT A SET;
   END;
END;
/

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
            CASE
               WHEN message_in IS NULL THEN 'Completed in:'
               ELSE '"' || message_in || '" completed in: '
            END
         || (DBMS_UTILITY.get_cpu_time - last_timing) / 100
         || ' seconds');

      /* Reset timer */
      start_timer;
   END;
END plch_timer;
/

DECLARE
   PROCEDURE compare_times (size_in         IN INTEGER,
                            iterations_in   IN INTEGER)
   IS
      l_numbers   plch_numbers_nt := plch_numbers_nt ();
   BEGIN
      l_numbers.EXTEND (size_in);

      FOR indx IN 1 .. size_in
      LOOP
         l_numbers (indx) := indx;
      END LOOP;

      plch_timer.start_timer;

      FOR indx IN 1 .. iterations_in
      LOOP
         IF plch_pkg.has_dups_table_op (l_numbers)
         THEN
            NULL;
         END IF;
      END LOOP;

      plch_timer.show_elapsed_time (
            'TABLE OPERATOR - Distinct for '
         || size_in
         || ' elements');

      FOR indx IN 1 .. iterations_in
      LOOP
         IF plch_pkg.has_dups_is_not_a_set (l_numbers)
         THEN
            NULL;
         END IF;
      END LOOP;

      plch_timer.show_elapsed_time (
            'IS NOT A SET - Distinct for '
         || size_in
         || ' elements');

      l_numbers (size_in / 2) := FLOOR (size_in / 2) + 1;

      FOR indx IN 1 .. iterations_in
      LOOP
         IF plch_pkg.has_dups_table_op (l_numbers)
         THEN
            NULL;
         END IF;
      END LOOP;

      plch_timer.show_elapsed_time (
            'TABLE OPERATOR - Not Distinct for '
         || size_in
         || ' elements');

      FOR indx IN 1 .. iterations_in
      LOOP
         IF plch_pkg.has_dups_is_not_a_set (l_numbers)
         THEN
            NULL;
         END IF;
      END LOOP;

      plch_timer.show_elapsed_time (
            'IS NOT A SET - Not Distinct for '
         || size_in
         || ' elements');
   END;
BEGIN
   compare_times (size_in => 100, iterations_in => 100);

   compare_times (size_in => 10000, iterations_in => 10);
END;
/

/* Clean up */

DROP TYPE plch_numbers_nt
/

DROP PACKAGE plch_pkg
/

DROP PACKAGE plch_timer
/