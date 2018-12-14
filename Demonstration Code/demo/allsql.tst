ALTER TABLE emp MODIFY sal NUMBER;

@ssoo
DECLARE
   v_user VARCHAR2(30);
   inlooptmr tmr_t := tmr_t.make ('IN LOOP', &&firstparm);
   allsqltmr tmr_t := tmr_t.make ('ALL SQL', &&firstparm);
BEGIN
   inlooptmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec IN (SELECT ename, sal FROM emp)
      LOOP
         UPDATE emp SET sal = rec.sal * 1.01
          WHERE ename = rec.ename;
      END LOOP;
   END LOOP;
   inlooptmr.stop;
   ROLLBACK;
   
   allsqltmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      UPDATE emp SET sal = sal * 1.01;
   END LOOP;
   allsqltmr.stop;
   ROLLBACK;
   
/*
SQL>  @allsql.tst 1000
Elapsed time for "IN LOOP" = 22.62 seconds. Per repetition timing = .02262 seconds.
Elapsed time for "ALL SQL" = 12.84 seconds. Per repetition timing = .01284 seconds.   
*/
END;
/
