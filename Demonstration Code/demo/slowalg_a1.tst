DECLARE
   str VARCHAR2(100);
   v_today VARCHAR2(20) := TO_CHAR (SYSDATE, 'MM/DD/YYYY');
   v_user VARCHAR2(30) := USER;

   CURSOR emp_cur
   IS
      SELECT last_name, TO_CHAR (SYSDATE, 'MM/DD/YYYY') today
        FROM employee;
           
   CURSOR emp2_cur
   IS
      SELECT SUBSTR (last_name, 1, 20) last_name FROM employee;
BEGIN
   sf_timer.start_timer;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec IN emp_cur
      LOOP
         IF LENGTH (rec.last_name) > 20
         THEN
            rec.last_name := SUBSTR (rec.last_name, 1, 20);
         END IF;
         str := rec.last_name;
         str := USER;
      END LOOP;
   END LOOP;
   sf_timer.show_elapsed_time ('Redundant');
   
   sf_timer.start_timer;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec IN emp2_cur
      LOOP
         str := rec.last_name;
         str := USER;
      END LOOP;
   END LOOP;
   sf_timer.show_elapsed_time ('Just once');
END;
/
