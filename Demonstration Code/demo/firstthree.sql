/* Formatted by PL/Formatter v3.0.5.0 on 2000/06/20 16:45 */

CREATE OR REPLACE PROCEDURE buy_catnip IS BEGIN NULL; END;
/
CREATE OR REPLACE PROCEDURE buy_milkbones IS BEGIN NULL; END;
/


CREATE OR REPLACE PROCEDURE firstthree (
   counter IN INTEGER,
   pet_type IN VARCHAR2
)
IS
   b BOOLEAN;
   v_first_three VARCHAR2(3);
BEGIN
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      v_first_three := SUBSTR (pet_type, 1, 3);

      IF v_first_three = 'CAT'
      THEN
         buy_catnip;
      ELSIF v_first_three = 'DOG'
      THEN
         buy_milkbones;
      END IF;
   END LOOP;

   sf_timer.show_elapsed_time ('substr');
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      IF pet_type LIKE 'CAT%'
      THEN
         buy_catnip;
      ELSIF pet_type LIKE 'DOG%'
      THEN
         buy_milkbones;
      END IF;
   END LOOP;

   sf_timer.show_elapsed_time ('like');
END;
/

exec firstthree (1000000, 'CAT-LONGHAIR');
exec firstthree (1000000, 'DOG-LONGHAIR');

CREATE OR REPLACE PROCEDURE firstthree (
   counter IN INTEGER,
   pet_type IN VARCHAR2
)
IS
   b BOOLEAN;
BEGIN
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      IF SUBSTR (pet_type, 1, 3) = 'CAT'
      THEN
         buy_catnip;
      END IF;
   END LOOP;

   sf_timer.show_elapsed_time ('substr');
   sf_timer.start_timer;

   FOR repind IN 1 .. counter
   LOOP
      IF pet_type LIKE 'CAT%'
      THEN
         buy_catnip;
      END IF;
   END LOOP;

   sf_timer.show_elapsed_time ('like');
END;
/

exec firstthree (1000000, 'CAT-LONGHAIR');
