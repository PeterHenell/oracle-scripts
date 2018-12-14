/* This version uses SYSTIMESTAMP, thanks to Elic */

CREATE OR REPLACE PACKAGE plch_timer
IS
   PROCEDURE start_timer;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL);
END plch_timer;
/

CREATE OR REPLACE PACKAGE BODY plch_timer
IS
   last_timing   TIMESTAMP;

   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := SYSTIMESTAMP;
   END;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            CASE
               WHEN message_in IS NULL THEN 'Completed in:'
               ELSE '"' || message_in || '" completed in: '
            END
         || REGEXP_SUBSTR (SYSTIMESTAMP - last_timing, 
               '([1-9][0-9:]*|0)\.\d{3}')
         || ' seconds');

      /* Reset timer */
      start_timer;
   END;
END plch_timer;
/