DECLARE
   CURSOR upd_of_sal_cur
   IS
      SELECT *
        FROM employee
        FOR UPDATE OF salary;
BEGIN
   sf_timer.start_timer;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec IN upd_of_sal_cur
      LOOP
         IF rec.commission IS NOT NULL
         THEN
            UPDATE employee
               SET commission = commission + 1
             WHERE CURRENT OF upd_of_sal_cur;
         END IF;
      END LOOP;
   END LOOP;
   sf_timer.show_elapsed_time ('WHERE CURRENT OF');
   ROLLBACK;
   
   sf_timer.start_timer;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec IN upd_of_sal_cur
      LOOP
         IF rec.commission IS NOT NULL
         THEN
            UPDATE employee
               SET commission = commission + 1
             WHERE employee_id = rec.employee_id;
         END IF;
      END LOOP;
   END LOOP;
   sf_timer.show_elapsed_time ('BY PRIMARY KEY');
   ROLLBACK;
         
END;
/

