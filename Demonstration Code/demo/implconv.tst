CREATE OR REPLACE PROCEDURE test_implicit_converstion (count_in IN PLS_INTEGER
                                                      )
IS
   num        NUMBER;
   str        VARCHAR2 (4000);
   dt         DATE;

   impl_tmr   tmr_t := tmr_t.make ('IMPLICIT', count_in);
   expl_tmr   tmr_t := tmr_t.make ('EXPLICIT', count_in);
BEGIN
   impl_tmr.reset ('IMPLICIT INTEGER TO FLOAT');
   impl_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      num := num + 1;
   END LOOP;

   impl_tmr.stop;

   expl_tmr.reset ('NO INTEGER TO FLOAT');
   expl_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      num := num + 1.0;
   END LOOP;

   expl_tmr.stop;

   impl_tmr.reset ('IMPLICIT INTEGER TO STRING');
   impl_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      str := str || DBMS_UTILITY.get_time;
      str := NULL;
   END LOOP;

   impl_tmr.stop;

   expl_tmr.reset ('EXPLICIT INTEGER TO STRING');
   expl_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      str := str || TO_CHAR (DBMS_UTILITY.get_time);
      str := NULL;
   END LOOP;

   expl_tmr.stop;

   impl_tmr.reset ('IMPLICIT STRING TO DATE');
   impl_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      dt := '01-JAN-99';
   END LOOP;

   impl_tmr.stop;

   expl_tmr.reset ('EXPLICIT STRING TO DATE');
   expl_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      dt := TO_DATE ('01-JAN-99');
   END LOOP;

   expl_tmr.stop;
END;
/

BEGIN
   test_implicit_converstion (1000000);
/*
SQL> @implconv.tst 1000000
Elapsed time for "IMPLICIT INTEGER TO FLOAT" = 1.88 seconds. Per repetition timing = .00000188 secon
Elapsed time for "NO INTEGER TO FLOAT" = 1.35 seconds. Per repetition timing = .00000135 seconds.
Elapsed time for "IMPLICIT INTEGER TO STRING" = 31.13 seconds. Per repetition timing = .00003113 sec
Elapsed time for "NO INTEGER TO STRING" = 30.2 seconds. Per repetition timing = .0000302 seconds.
Elapsed time for "IMPLICIT STRING TO DATE" = 24.69 seconds. Per repetition timing = .00002469 second
Elapsed time for "EXPLICIT STRING TO DATE" = 24.65 seconds. Per repetition timing = .00002465 second
*/
END;
/