/*
-- Compare performance of INSTR-REPLACE with straight REPLACE
-- in which large percentage of strings do NOT contain a string to replace.
*/

CREATE OR REPLACE PROCEDURE compare_perf (count_in IN PLS_INTEGER := 100000)
IS
   v                VARCHAR2 (30);
   repl_tmr         tmr_t           := tmr_t.make ('INSTR-REPLACE', count_in);
   instr_repl_tmr   tmr_t           := tmr_t.make ('REPLACE', count_in);

   TYPE maxvarchar2_aat IS TABLE OF VARCHAR2 (32767)
      INDEX BY BINARY_INTEGER;

   l_strings        maxvarchar2_aat;
BEGIN
   FOR indx IN 1 .. 1000
   LOOP
      IF MOD (indx, 100) = 0
      THEN
         l_strings (indx) :=
                'this is a string without anything to replace out again here';
      ELSE
         l_strings (indx) :=
              'this is a string with XXX something to replace XXX again here';
      END IF;
   END LOOP;

   repl_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      FOR indx IN 1 .. 1000
      LOOP
         v := REPLACE (l_strings (indx), 'XXX', 'YYY');
      END LOOP;
   END LOOP;

   repl_tmr.STOP;
   instr_repl_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      FOR indx IN 1 .. 1000
      LOOP
         IF INSTR (l_strings (indx), 'XXX') > 0
         THEN
            v := REPLACE (l_strings (indx), 'XXX', 'YYY');
         END IF;
      END LOOP;
   END LOOP;

   instr_repl_tmr.STOP;
END;
/

BEGIN
   compare_perf (1000);
   compare_perf (100000);
END;
/