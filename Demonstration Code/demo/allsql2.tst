@ssoo
DECLARE
   v_name VARCHAR2(30);
   onecurtmr tmr_t := tmr_t.make ('JOINED', &&1);
   twocurtmr tmr_t := tmr_t.make ('TWO CURSORS', &&1);

   CURSOR join_cur
   IS
      SELECT e.last_name
        FROM department d, employee e
       WHERE d.department_id = e.department_id;
       
   CURSOR dept_cur
   IS
      SELECT department_id
        FROM department d;
   
   CURSOR emp_cur (deptID in department.department_id%TYPE)
   IS
      SELECT e.last_name
        FROM employee e
       WHERE department_id = deptID;
       
BEGIN
   onecurtmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      FOR rec IN join_cur
      LOOP
         v_name := rec.last_name;
      END LOOP;
   END LOOP;
   onecurtmr.stop;
   ROLLBACK;
   
   twocurtmr.go;
   FOR indx IN 1 .. &&1
   LOOP
      FOR rec IN dept_cur
      LOOP
         FOR erec IN emp_cur (rec.department_id)
         LOOP
            v_name := erec.last_name;
         END LOOP;
      END LOOP;
   END LOOP;
   twocurtmr.stop;
   ROLLBACK;
   
/*
SQL> @allsql2.tst 1000
Elapsed time for "JOINED" = 5.45 seconds. Per repetition timing = .00545 seconds.
Elapsed time for "TWO CURSORS" = 10.37 seconds. Per repetition timing = .01037 seconds.
*/
END;
/
