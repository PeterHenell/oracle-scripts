@datemgr2.pkg

DECLARE
   v VARCHAR2(30);
   todate_tmr tmr_t := tmr_t.make ('TO_DATE', &&firstparm);
   dtval_tmr tmr_t := tmr_t.make ('dt.val', &&firstparm);
BEGIN
   todate_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      v := TO_DATE ('19991230', 'YYYYMMDD');
   END LOOP;
   todate_tmr.stop;

   dtval_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      v := dt.val ('19991230');
   END LOOP;
   dtval_tmr.stop;
END;
/

undefine firstparm
