@@lstrip1.sf
@@lstrip3.sf
@@lstrip2.sf

CREATE OR REPLACE PROCEDURE lstrip_test 
   (counter IN INTEGER, 
    str_in IN VARCHAR2, 
    substr_in IN VARCHAR2, 
    numstrip IN INTEGER)
IS
   str VARCHAR2(32767);
   timing1 VARCHAR2(1000);
   timing2 VARCHAR2(1000);
BEGIN
   PLVtmr.set_factor (counter);

   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      str := lstrip1 (str_in, substr_in, numstrip);
      IF repind = 1
      THEN
         p.l (str);
      END IF;
   END LOOP;
   timing1 := PLVtmr.elapsed_message ('Recursion');
   
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      str := lstrip2 (str_in, substr_in, numstrip);
      IF repind = 1
      THEN
         p.l (str);
      END IF;
   END LOOP;
   timing2 := PLVtmr.elapsed_message ('WHILE Loop-No Recursion');
   
   sf_timer.start_timer;
   FOR repind IN 1 .. counter
   LOOP
      str := lstrip3 (str_in, substr_in, numstrip);
      IF repind = 1
      THEN
         p.l (str);
      END IF;
   END LOOP;
   
   sf_timer.show_elapsed_time ('WHILE Loop-SUBSTR Only');
   p.l (timing1);
   p.l (timing2);
   
END;
/

BEGIN
   lstrip_test (&&firstparm, 
      LPAD ('abc', 5000, 'def'), 'def', 1000);
/*
SQL> @lstrip.tst 10
WHILE Loop-SUBSTR Only Elapsed: 1.3 seconds. Factored: .13 seconds.
Recursion Elapsed: 6.85 seconds. Factored: .685 seconds.
WHILE Loop-No Recursion Elapsed: 3.62 seconds. Factored: .362 seconds.
*/      
END;
/