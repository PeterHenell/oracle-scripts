BEGIN
   /* Show the conflict resolution logic with a tiny hash table
      whose starting value is right at the end of the valid range. */
   altind.trc (2**31-5, 20);
   altind.loadcache;
   altind.notrc;
   altind.loadcache;
END;
/

CREATE OR REPLACE PROCEDURE altind_compare (
   counter IN INTEGER,
   ename_in IN VARCHAR2
   )
/* Compare performance of hash scan and full table scan. */
IS
   emprec employee%ROWTYPE;
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      emprec := altind.onerow (ename_in, TRUE);
      IF i = 1
      THEN
         p.l (emprec.employee_id);
      END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('Hash');
   
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      emprec := altind.onerow (ename_in, FALSE);
      IF i = 1
      THEN
         p.l (emprec.employee_id);
      END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('Full index-by scan');
   
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      emprec := altind.onerow_dbind (ename_in);
      IF i = 1
      THEN
         p.l (emprec.employee_id);
      END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('Indexed DB lookup');
   
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR i IN 1 .. counter
   LOOP
      emprec := altind.onerow_dbnoind (ename_in);
      IF i = 1
      THEN
         p.l (emprec.employee_id);
      END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('Non-indexed DB lookup');
END;
/

BEGIN
   p.l ('Testing for SMITH');
   altind_compare (1000, 'SMITH');
END;
/

BEGIN
   p.l ('Testing for WEST');
   altind_compare (1000, 'WEST');
END;
/

BEGIN
   p.l ('Testing for MURRAY');
   altind_compare (1000, 'MURRAY');
END;
/