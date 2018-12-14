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

CREATE OR REPLACE FUNCTION plch_big_enough
   RETURN BOOLEAN
IS
   l_number   NUMBER;
BEGIN
   FOR indx IN 1 .. 10000000
   LOOP
      l_number := l_number + 1;
   END LOOP;

   RETURN l_number > 10000;
END;
/

DECLARE
   l_approved   BOOLEAN := FALSE;
BEGIN
   plch_timer.start_timer;

   IF l_approved OR plch_big_enough
   THEN
      DBMS_OUTPUT.put_line ('All systems go');
   END IF;

   plch_timer.show_elapsed_time;
END;
/

DECLARE
   l_approved   BOOLEAN := FALSE;
BEGIN
   plch_timer.start_timer;

   IF plch_big_enough OR l_approved
   THEN
      DBMS_OUTPUT.put_line ('All systems go');
   END IF;

   plch_timer.show_elapsed_time;
END;
/

DECLARE
   l_approved   BOOLEAN := TRUE;
BEGIN
   plch_timer.start_timer;

   IF l_approved OR plch_big_enough
   THEN
      DBMS_OUTPUT.put_line ('All systems go');
   END IF;

   plch_timer.show_elapsed_time;
END;
/

DECLARE
   l_approved   BOOLEAN := TRUE;

   l_flag       BOOLEAN;
BEGIN
   plch_timer.start_timer;

   l_flag := plch_big_enough;

   IF l_approved OR l_flag
   THEN
      DBMS_OUTPUT.put_line ('All systems go');
   END IF;

   plch_timer.show_elapsed_time;
END;
/

/* Clean up */

DROP function plch_big_enough
/

DROP PACKAGE plch_timer
/