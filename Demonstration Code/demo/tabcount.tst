@@tabcount.sf
@@tabcount81.sf

CREATE OR REPLACE PROCEDURE test_dynsql (
   counter IN INTEGER)
IS
   tc PLS_INTEGER;
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      tc := tabcount (user, 'employee');
      IF repind = 1 THEN p.l (tc); END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('DBMS_SQL');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      tc := tabcount81 (user, 'employee');
      IF repind = 1 THEN p.l (tc); END IF;
   END LOOP;
   sf_timer.show_elapsed_time ('Native');
END;
/
