SET VERIFY OFF

CREATE OR REPLACE PROCEDURE proc1
/* Do nothing procedure */
IS
BEGIN
   NULL;
END;
/

CREATE OR REPLACE PROCEDURE proc2 (inout IN OUT VARCHAR2)
/* Do nothing with IN OUT procedure */
IS
BEGIN
   inout := 'Steven';
END;
/

CREATE OR REPLACE FUNCTION func RETURN INTEGER
/* Do little function */
IS
BEGIN
   RETURN 1;
END;
/

CREATE OR REPLACE PROCEDURE test_mod_overhead (counter IN INTEGER)
IS
   int INTEGER;
   var VARCHAR2(30);
BEGIN
   PLVtmr.set_factor (counter);
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      NULL;
   END LOOP;
   sf_timer.show_elapsed_time ('In line NULL');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      proc1;
   END LOOP;
   sf_timer.show_elapsed_time ('NULL procedure call');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      proc2 (var);
   END LOOP;
   sf_timer.show_elapsed_time ('INOUT procedure call');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      int := 1;
   END LOOP;
   sf_timer.show_elapsed_time ('In line assignment');

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      int := func;
   END LOOP;
   sf_timer.show_elapsed_time ('Function call');
END;
/
