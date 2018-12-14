CONNECT SCOTT/TiGER

@@tmr81.ot

/* Formatted on 2002/06/11 10:28 (Formatter Plus v4.6.6) */
CREATE OR REPLACE PROCEDURE count_emp_definer
AUTHID DEFINER
IS 
   n   INTEGER;
BEGIN
   SELECT   COUNT (*)
       INTO n
       FROM employee e, department d
      WHERE d.department_id IS NOT NULL
        AND e.department_id = d.department_id
        AND e.employee_id IN (SELECT employee_id
                                FROM employee e2
                               WHERE salary = (SELECT MAX (salary)
                                                 FROM employee))
        AND last_name LIKE 'S%'
   ORDER BY DECODE (
               d.department_id,
               10, SYSDATE,
               20, SYSDATE + 50,
               30, ADD_MONTHS (SYSDATE, 50),
               40, SYSDATE + 500
            );
END;
/
grant execute on count_emp_definer to demo;

CREATE OR REPLACE PROCEDURE count_emp_invoker
AUTHID CURRENT_USER
IS 
   n   INTEGER;
BEGIN
   SELECT   COUNT (*)
       INTO n
       FROM employee e, department d
      WHERE d.department_id IS NOT NULL
        AND e.department_id = d.department_id
        AND e.employee_id IN (SELECT employee_id
                                FROM employee e2
                               WHERE salary = (SELECT MAX (salary)
                                                 FROM employee))
        AND last_name LIKE 'S%'
   ORDER BY DECODE (
               d.department_id,
               10, SYSDATE,
               20, SYSDATE + 50,
               30, ADD_MONTHS (SYSDATE, 50),
               40, SYSDATE + 500
            );
END;
/
grant execute on count_emp_invoker to demo;

CREATE OR REPLACE PROCEDURE count_emp_nds_definer
AUTHID DEFINER
IS 
   n   INTEGER;
BEGIN
   EXECUTE IMMEDIATE 
   '   SELECT   COUNT (*)       
       FROM employee e, department d
      WHERE d.department_id IS NOT NULL
        AND e.department_id = d.department_id
        AND e.employee_id IN (SELECT employee_id
                                FROM employee e2
                               WHERE salary = (SELECT MAX (salary)
                                                 FROM employee))
        AND last_name LIKE ''S%''
   ORDER BY DECODE (
               d.department_id,
               10, SYSDATE,
               20, SYSDATE + 50,
               30, ADD_MONTHS (SYSDATE, 50),
               40, SYSDATE + 500
            )' INTO n;
END;
/
grant execute on count_emp_nds_definer to demo;

CREATE OR REPLACE PROCEDURE count_emp_nds_invoker
AUTHID CURRENT_USER
IS 
   n   INTEGER;
BEGIN
   EXECUTE IMMEDIATE 
     '   SELECT   COUNT (*)       
       FROM employee e, department d
      WHERE d.department_id IS NOT NULL
        AND e.department_id = d.department_id
        AND e.employee_id IN (SELECT employee_id
                                FROM employee e2
                               WHERE salary = (SELECT MAX (salary)
                                                 FROM employee))
        AND last_name LIKE ''S%''
   ORDER BY DECODE (
               d.department_id,
               10, SYSDATE,
               20, SYSDATE + 50,
               30, ADD_MONTHS (SYSDATE, 50),
               40, SYSDATE + 500
            )' INTO n;
END;
/
grant execute on count_emp_nds_invoker to demo;

grant select on department to demo;
grant select on employee to demo;

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
10000 iterations

Elapsed time for "Definer rights" = 5.94 seconds. Per repetition timing = .000594 seconds.
Elapsed time for "Invoker rights" = 9.99 seconds. Per repetition timing = .000999 seconds.
Elapsed time for "Definer rights with NDS" = 8.73 seconds. Per repetition timing = .000873 seconds.
Elapsed time for "Invoker rights with NDS" = 14.38 seconds. Per repetition timing = .001438 seconds..
*/