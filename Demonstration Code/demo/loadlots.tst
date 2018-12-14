@ssoo
@tmr81.ot
@Loadlots1.sp
@Loadlots2.sp
@Loadlots3.sp
@Loadlots4.sp
@Loadlots5.sp
@Loadlots6.sp 
@Loadlots7.sp 
DECLARE
   
/* Keep iterations down to 10 in a class. */

   orig_tmr     tmr_t := tmr_t.make ('Original', &&1);
   bind_tmr     tmr_t := tmr_t.make ('One Parse', &&1);
   nobind_tmr   tmr_t := tmr_t.make ('No Binds', &&1);
   nds_tmr      tmr_t := tmr_t.make ('NDS', &&1);
   bulk_tmr     tmr_t := tmr_t.make ('BULK DBMS_SQL', &&1);
   forall8i_tmr   tmr_t := tmr_t.make ('FORALL 8i', &&1);
   forall9i_tmr   tmr_t := tmr_t.make ('FORALL 9i', &&1);
BEGIN
   orig_tmr.GO;

   FOR indx IN 1 .. &&1
   LOOP
      Loadlots1 ('emp');
      ROLLBACK;
   END LOOP;

   orig_tmr.STOP;
   bind_tmr.GO;

   FOR indx IN 1 .. &&1
   LOOP
      Loadlots2 ('emp');
      ROLLBACK;
   END LOOP;

   bind_tmr.STOP;
   nobind_tmr.GO;

   FOR indx IN 1 .. &&1
   LOOP
      Loadlots3 ('emp');
      ROLLBACK;
   END LOOP;

   nobind_tmr.STOP;
   nds_tmr.GO;

   FOR indx IN 1 .. &&1
   LOOP
      Loadlots4 ('emp');
      ROLLBACK;
   END LOOP;

   nds_tmr.STOP;
   bulk_tmr.GO;

   FOR indx IN 1 .. &&1
   LOOP
      Loadlots5 ('emp');
      ROLLBACK;
   END LOOP;

   bulk_tmr.STOP;
   
   forall8i_tmr.GO;

   FOR indx IN 1 .. &&1
   LOOP
      Loadlots6 ('emp');
      ROLLBACK;
   END LOOP;

   forall8i_tmr.STOP;
   
   forall9i_tmr.GO;

   FOR indx IN 1 .. &&1
   LOOP
      Loadlots6 ('emp');
      ROLLBACK;
   END LOOP;

   forall9i_tmr.STOP;

/*
For 10 iterations...
Elapsed time for "Original" = 22.1 seconds. Per repetition timing = 2.21 seconds.
Elapsed time for "One Parse" = 12.24 seconds. Per repetition timing = 1.224 seconds.
Elapsed time for "No Binds" = 11.57 seconds. Per repetition timing = 1.157 seconds.
Elapsed time for "NDS" = 21.32 seconds. Per repetition timing = 2.132 seconds.
Elapsed time for "BULK DBMS_SQL" = 9.07 seconds. Per repetition timing = .907 seconds.
Elapsed time for "FORALL 8i" = 1.22 seconds. Per repetition timing = .122 seconds.
Elapsed time for "FORALL 9i" = 1.19 seconds. Per repetition timing = .119 seconds.

Elapsed time for "Original" = 25.55 seconds. Per repetition timing = 2.555 seconds.
Elapsed time for "One Parse" = 12.8 seconds. Per repetition timing = 1.28 seconds.
Elapsed time for "No Binds" = 10.17 seconds. Per repetition timing = 1.017 seconds.
Elapsed time for "NDS" = 17.2 seconds. Per repetition timing = 1.72 seconds.
Elapsed time for "BULK DBMS_SQL" = 6.21 seconds. Per repetition timing = .621 seconds.
Elapsed time for "FORALL 8i" = .65 seconds. Per repetition timing = .065 seconds.
Elapsed time for "FORALL 9i" = .51 seconds. Per repetition timing = .051 seconds.
*/

END;
/
