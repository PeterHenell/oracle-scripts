CREATE OR REPLACE PROCEDURE test_isnum2 (
   counter IN INTEGER,
   str IN VARCHAR2)
IS
   b BOOLEAN;
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      b := isnum (str);
      IF repind = 1
      THEN
         p.l (b);
      END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('TO NUMBER');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      b := isnum_impl (str);
      IF repind = 1
      THEN
         p.l (b);
      END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('SUBTRACTION');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      b := isnum_ch (str);
      IF repind = 1
      THEN
         p.l (b);
      END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('SUBSTR');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      b := isnum_ch2 (str);
      IF repind = 1
      THEN
         p.l (b);
      END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('TRANSLATE');

END;
