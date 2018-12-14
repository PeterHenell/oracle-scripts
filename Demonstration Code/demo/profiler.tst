CREATE OR REPLACE PACKAGE analysis
IS 
   FUNCTION caseload (emp_in IN NUMBER)
      RETURN INTEGER;

   FUNCTION avg_cases (dept_in IN NUMBER)
      RETURN INTEGER;
END analysis;
/


CREATE OR REPLACE PACKAGE BODY analysis
IS 
   FUNCTION caseload (emp_in IN NUMBER)
      RETURN INTEGER
   IS 
      n   INTEGER;
   BEGIN
      FOR indx IN 1 .. 1
      LOOP
         FOR rec IN (SELECT e1.last_name, e2.first_name
                       FROM employee e1, employee e2)
         LOOP
            NULL;
         END LOOP;
      END LOOP;

      RETURN 50;
   END;

   FUNCTION avg_cases (dept_in IN NUMBER)
      RETURN INTEGER
   IS 
      n   INTEGER;
   BEGIN
      FOR indx IN 1 .. 1
      LOOP
         FOR rec IN (SELECT e1.last_name, e2.first_name, e3.hire_date
                       FROM employee e1, employee e2, employee e3)
         LOOP
            NULL;
         END LOOP;
      END LOOP;

      RETURN 100;
   END;
END analysis;
/


CREATE OR REPLACE PROCEDURE assign_workload (department_in IN NUMBER)
IS 
   case#   INTEGER;

   CURSOR emp_cur
   IS
      SELECT ename, empno
        FROM emp
       WHERE deptno = department_in
          OR department_in = 0;

   PROCEDURE assign_next_open_case (emp_id_in IN NUMBER, case_out OUT NUMBER)
   IS
      n   INTEGER;
   BEGIN
      FOR indx IN 1 .. 100
      LOOP
         FOR rec IN (SELECT * from department)
         LOOP
            NULL;
         END LOOP;
      END LOOP;
   END;

   FUNCTION next_appointment (case_id_in IN NUMBER)
      RETURN DATE
   IS
      n   INTEGER;
   BEGIN
      FOR indx IN 1 .. 5
      LOOP
         FOR rec IN (SELECT e1.empno FROM emp e1, emp, emp)
         LOOP
            NULL;
         END LOOP;
      END LOOP;
      RETURN SYSDATE;
   END;

   PROCEDURE schedule_case (case_in IN NUMBER, date_in IN DATE)
   IS
   BEGIN
      IF case_in IS NOT NULL AND date_in > SYSDATE
      THEN
         /* Do stuff here. */
         NULL;
      END IF;
   END;
BEGIN   /* main */
   FOR emp_rec IN emp_cur
   LOOP
      IF analysis.caseload (emp_rec.empno) <
                                           analysis.avg_cases (department_in)
      THEN
         assign_next_open_case (emp_rec.empno, case#);
         schedule_case (case#, next_appointment (case#));
      END IF;
   END LOOP;
END assign_workload;
/
