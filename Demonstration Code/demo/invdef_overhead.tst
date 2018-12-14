CONNECT SCOTT/TiGER

@@tmr81.ot

CREATE OR REPLACE PROCEDURE count_emp_definer
AUTHID DEFINER
IS 
   n   INTEGER;
BEGIN
   SELECT COUNT (*) into n FROM emp;
END;
/
grant execute on count_emp_definer to demo;

CREATE OR REPLACE PROCEDURE count_emp_invoker
AUTHID CURRENT_USER
IS 
   n   INTEGER;
BEGIN
   SELECT COUNT (*) into n FROM emp;
END;
/
grant execute on count_emp_invoker to demo;

CREATE OR REPLACE PROCEDURE count_emp_nds_definer
AUTHID DEFINER
IS 
   n   INTEGER;
BEGIN
   EXECUTE IMMEDIATE 
   'SELECT COUNT (*) FROM emp' INTO n;
END;
/
grant execute on count_emp_nds_definer to demo;

CREATE OR REPLACE PROCEDURE count_emp_nds_invoker
AUTHID CURRENT_USER
IS 
   n   INTEGER;
BEGIN
   EXECUTE IMMEDIATE 
   'SELECT COUNT (*) FROM emp' INTO n;
END;
/
grant execute on count_emp_nds_invoker to demo;

CONNECT demo/demo
SET SERVEROUTPUT ON SIZE 1000000 FORMAT WRAPPED

DECLARE
   v VARCHAR2(30);
   definer_tmr scott.tmr_t := scott.tmr_t.make ('Definer rights', &&1);
   invoker_tmr scott.tmr_t := scott.tmr_t.make ('Invoker rights', &&1);
   nds_definer_tmr scott.tmr_t := scott.tmr_t.make ('Definer rights with NDS', &&1);
   nds_invoker_tmr scott.tmr_t := scott.tmr_t.make ('Invoker rights with NDS', &&1);
BEGIN
   definer_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      scott.count_emp_definer;
   END LOOP;
   definer_tmr.stop;

   invoker_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      scott.count_emp_invoker;
   END LOOP;
   invoker_tmr.stop;
   
   nds_definer_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      scott.count_emp_nds_definer;
   END LOOP;
   nds_definer_tmr.stop;

   nds_invoker_tmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      scott.count_emp_nds_invoker;
   END LOOP;
   nds_invoker_tmr.stop;
END;
/

/*
20000 iterations

Elapsed time for "Definer rights" = 3.1 seconds. Per repetition timing = .000155 seconds.
Elapsed time for "Invoker rights" = 4.2 seconds. Per repetition timing = .00021 seconds.
Elapsed time for "Definer rights with NDS" = 9.58 seconds. Per repetition timing = .000479 seconds.
Elapsed time for "Invoker rights with NDS" = 10.98 seconds. Per repetition timing = .000549 seconds.
*/
