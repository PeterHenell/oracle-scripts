CREATE OR REPLACE PROCEDURE test_isnum (
   counter IN INTEGER,
   str IN VARCHAR2)
IS
   b BOOLEAN;
BEGIN
   tmr.capture;
   FOR repind IN 1 .. counter
   LOOP
      b := isnum (str);
      IF repind = 1
      THEN
         p.l (b);
      END IF;
   END LOOP;
   tmr.show_elapsed;

   tmr.capture;
   FOR repind IN 1 .. counter
   LOOP
      b := isnum_impl (str);
      IF repind = 1
      THEN
         p.l (b);
      END IF;
   END LOOP;
   tmr.show_elapsed;

   tmr.capture;
   FOR repind IN 1 .. counter
   LOOP
      b := isnum_ch (str);
      IF repind = 1
      THEN
         p.l (b);
      END IF;
   END LOOP;
   tmr.show_elapsed;

   tmr.capture;
   FOR repind IN 1 .. counter
   LOOP
      b := isnum_ch2 (str);
      IF repind = 1
      THEN
         p.l (b);
      END IF;
   END LOOP;
   tmr.show_elapsed;

END;
