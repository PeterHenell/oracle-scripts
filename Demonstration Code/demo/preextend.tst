/*
|| Summary: Test efficiency of pre-extending nested table vs
||    incremental extending and use of index-by tables.
||
|| Watch out for running out of memory with a very large value
|| for &&1: with 1000000, my 128MB system was drained...
*/
DROP TYPE nested_t FORCE;

CREATE OR REPLACE TYPE nested_t AS TABLE OF NUMBER;
/

DECLARE
   val PLS_INTEGER;
   TYPE ibtab_t IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
   ibtab ibtab_t;
   nesttab nested_t := nested_t();
   nestpretab nested_t := nested_t();
   nested_tmr tmr_t := tmr_t.make ('Nested Table', &&1);
   nested_pre_tmr tmr_t := tmr_t.make ('Nested Table Pre-Extended', &&1);
   ibtab_tmr tmr_t := tmr_t.make ('IB Table', &&1);
BEGIN
   p.l ('Populate collections with &&1 values');
   nested_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      nesttab.EXTEND(1);
      nesttab(indx) := indx;
   END LOOP;
   nested_tmr.stop;

   nested_pre_tmr.go;
   nestpretab.EXTEND(&&1);
   FOR indx IN 1 .. &&1
   LOOP
      nestpretab(indx) := indx;
   END LOOP;
   nested_pre_tmr.stop;

   ibtab_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      ibtab(indx) := indx;
   END LOOP;
   ibtab_tmr.stop;

   nested_tmr.reset;
   nested_pre_tmr.reset;
   ibtab_tmr.reset;

   p.l ('Access Nth Value');
   nested_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      val := nesttab(&&1/2);
   END LOOP;
   nested_tmr.stop;

   nested_pre_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      val := nestpretab(&&1/2);
   END LOOP;
   nested_pre_tmr.stop;

   ibtab_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      val := ibtab(&&1/2);
   END LOOP;
   ibtab_tmr.stop;

   nestpretab.DELETE;
   nesttab.DELETE;
   ibtab.DELETE;
   DBMS_SESSION.FREE_UNUSED_USER_MEMORY;
/*
Some results:

Populate collections with 500000 values
Elapsed time for "Nested Table" = 5.13 seconds. Per repetition timing = .00001026 seconds.
Elapsed time for "Nested Table Pre-Extended" = 3.87 seconds. Per repetition timing = .00000774 seconds.
Elapsed time for "IB Table" = 3.21 seconds. Per repetition timing = .00000642 seconds.
Access Nth Value
Elapsed time for "Nested Table" = 5.45 seconds. Per repetition timing = .0000109 seconds.
Elapsed time for "Nested Table Pre-Extended" = 7.17 seconds. Per repetition timing = .00001434 seconds.
Elapsed time for "IB Table" = 5.55 seconds. Per repetition timing = .0000111 seconds.

*/
END;
/
