/* Formatted by PL/Formatter v3.0.5.0 on 2000/06/20 16:45 */

CREATE OR REPLACE FUNCTION escaping (str IN VARCHAR2)
   RETURN BOOLEAN
IS
BEGIN
   RETURN str LIKE '!%';
END;
/
CREATE OR REPLACE PROCEDURE firstchar (
   counter IN INTEGER,
   str IN VARCHAR2
)
IS
   b BOOLEAN;
BEGIN
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      b := SUBSTR (str, 1, 1) = '!';
   END LOOP;

   sf_timer.show_elapsed_time ('substr');
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      b := str LIKE '!%';
   END LOOP;

   sf_timer.show_elapsed_time ('like');
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      b := escaping (str);
   END LOOP;

   sf_timer.show_elapsed_time ('function');
END;
/

exec firstchar (1000000, 'which is best?');
