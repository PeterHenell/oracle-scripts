CREATE TABLE trclog (str VARCHAR2(200));

CREATE OR REPLACE PROCEDURE trctst (
   counter IN INTEGER)
IS
   num INTEGER;
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      UPDATE emp SET sal = 1000 WHERE empno = 7782;
   END LOOP;
   sf_timer.show_elapsed_time ('No trace');

   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      INSERT INTO trclog VALUES (repind);
      UPDATE emp SET sal = 1000 WHERE empno = 7782;
   END LOOP;
   sf_timer.show_elapsed_time ('With straight insert');

   SELECT COUNT(*) INTO num FROM trclog;
   p.l (num);

ROLLBACK;

   PLVtrc.log;
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      PLVtrc.show ('abc');
      UPDATE emp SET sal = 1000 WHERE empno = 7782;
   END LOOP;
   sf_timer.show_elapsed_time ('With PLVtrc to table');

   SELECT COUNT(*) INTO num FROM plvision.plv_log;
   p.l (num);

ROLLBACK;
/* Unpinned
No trace Elapsed: .22 seconds. Factored: .0022 seconds.
With straight insert Elapsed: .65 seconds. Factored: .0065 seconds.
100
With PLVtrc to table Elapsed: 10.97 seconds. Factored: .1097 seconds.
105
*/
END;
/