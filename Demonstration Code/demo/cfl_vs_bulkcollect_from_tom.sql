CREATE OR REPLACE PROCEDURE simple_test (p_iters IN NUMBER DEFAULT 1)
AS
   l_start_cpu   NUMBER := DBMS_UTILITY.get_cpu_time;
   l_start_ela   NUMBER := DBMS_UTILITY.get_time;
   type r is record (cv sys_refcursor);
   rr r;
BEGIN
open rr.cv for select * from employees;
   FOR iters IN 1 .. p_iters
   LOOP
      FOR x IN (SELECT *
                  FROM employees_big)
      LOOP
         IF (x.employee_id + 0.1 = x.employee_id)
         THEN
            DBMS_OUTPUT.put_line ('doh');
         END IF;
      END LOOP;

      DBMS_OUTPUT.put_line (   iters
                            || '-simple '
                            || ' cpu = '
                            || (DBMS_UTILITY.get_cpu_time - l_start_cpu)
                            || ' ela = '
                            || (DBMS_UTILITY.get_time - l_start_ela)
                           );
   END LOOP;
END;
/