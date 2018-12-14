@@ssoo
@@slowsql_q2.sql
@@slowsql_a2.sql
@@slowsql_a2_2.sql
DECLARE
   v_user VARCHAR2(30);
   bind_tmr tmr_t := tmr_t.make ('Binds', &&firstparm);
   bulkbind_tmr tmr_t := tmr_t.make ('Bulk Binds', &&firstparm);
   nobind_tmr tmr_t := tmr_t.make ('No Binds', &&firstparm);
BEGIN
   bind_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      bindall;
      ROLLBACK;
   END LOOP;
   bind_tmr.stop;
   
   bulkbind_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      bulkbindall;
      ROLLBACK;
   END LOOP;
   bulkbind_tmr.stop;
   
   nobind_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      bindnone;
      ROLLBACK;
   END LOOP;
   nobind_tmr.stop;
/*
SQL>  @slowsql_a2.tst 10
Input truncated to 1 characters
Elapsed time for "Binds" = 28.34 seconds. Per repetition timing = 2.834 seconds.
Elapsed time for "No Binds" = 20.41 seconds. Per repetition timing = 2.041 seconds.   
*/   
END;
/