@@tmr81.ot
@@thisuser.pkg
DECLARE
   v VARCHAR2(30);
   insql_tmr tmr_t := tmr_t.make ('in SQL', &&firstparm);
   inplsql_tmr tmr_t := tmr_t.make ('in PLSQL', &&firstparm);
   
   CURSOR emp_cur IS
      SELECT UPPER (first_name) fname, SUBSTR (last_name, 2, 6) lname
        FROM employee;
        
   myRec emp_cur%ROWTYPE;
BEGIN
   insql_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec in emp_cur
      LOOP
         myRec.fname := rec.fname;
         myRec.lname := rec.lname;
      END LOOP;
   END LOOP;
   insql_tmr.stop;

   inplsql_tmr.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec in emp_cur
      LOOP
         myRec.fname := UPPER (rec.fname);
         myRec.lname := SUBSTR (rec.lname, 2, 6);
      END LOOP;
   END LOOP;
   inplsql_tmr.stop;
END;
/
/*
10000 iterations
Elapsed time for "in SQL" = 18.8 seconds. Per repetition timing = .00188 seconds.
Elapsed time for "in PLSQL" = 23.24 seconds. Per repetition timing = .002324 seconds.
*/