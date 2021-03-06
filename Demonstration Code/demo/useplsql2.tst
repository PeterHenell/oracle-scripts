/* Just run once to set up -- takes a while!
DROP TABLE EMPLOYEE_big;
DROP TABLE DEPARTMENT_big;
CREATE TABLE EMPLOYEE_big AS SELECT * FROM EMPLOYEE;
ALTER TABLE EMPLOYEE_big MODIFY EMPLOYEE_ID NUMBER;
ALTER TABLE EMPLOYEE_big MODIFY SALARY NUMBER;

DECLARE
-- Put lots of rows into the table
   maxnum PLS_InTEGER;
BEGIN
   FOR indx IN 1 .. 10000
   LOOP
      SELECT MAX (employee_id) INTO maxnum FROM employee_big;

      INSERT INTO EMPLOYEE_big (
         employee_id, last_name, first_name, salary, department_id,
         hire_date,  CREATED_BY, CREATED_ON,CHANGED_BY, CHANGED_ON     )
      VALUES (
         maxnum + 1,
         'Feuerstein' || indx, 'Steven',
         indx,
         MOD (indx, 4) * 10,
         SYSDATE, USER, SYSDATE, USER, SYSDATE);
   END LOOP;
END;
/

CREATE INDEX I_EMP2_DEPT ON EMPLOYEE_big (DEPARTMENT_ID, salary);
CREATE TABLE DEPARTMENT_big AS SELECT * FROM DEPARTMENT;
*/

DECLARE
/* Warning: PL/SQL approach seems to be SLOWER! */
   str VARCHAR2(1000);

   tmr1 tmr_t := tmr_t.make ('ALL SQL', &&firstparm);
   tmr2 tmr_t := tmr_t.make ('SOME PL/SQL', &&firstparm);

   /* Utrecht 12/99: use in line view for better performance */
   
   CURSOR allsql_cur IS
      SELECT 'Top employee in ' || E.department_id || ' is ' ||
               E.last_name || ', ' || E.first_name str
        FROM employee_big E,
             (SELECT department_id, MAX (salary) max_salary
        FROM employee_big E
       GROUP BY department_id) MS
       WHERE E.salary = MS.max_salary
         AND E.department_id = MS.department_id;

   CURSOR dept_cur IS
      SELECT department_id, MAX (salary) max_salary
        FROM employee_big E
       GROUP BY department_id;

   CURSOR emp_cur (
      dept IN department.department_id%TYPE,
      maxsal IN NUMBER)
   IS
      SELECT 'Top employee in ' || department_id || ' is ' ||
             last_name || ', ' || first_name str
        FROM employee_big
       WHERE department_id = dept
         AND salary = maxsal;

BEGIN
   tmr1.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR rec IN allsql_cur
      LOOP
         str := rec.str;
      END LOOP;
   END LOOP;
   tmr1.stop;

   tmr2.go;
   FOR indx IN 1 .. &&firstparm
   LOOP
      FOR dept_rec IN dept_cur
      LOOP
         FOR rec IN emp_cur (dept_rec.department_id, dept_rec.max_salary)
         LOOP
             str := rec.str;
         END LOOP;
      END LOOP;
   END LOOP;
   tmr2.stop;
/*
For 100 iterations with 10000+ rows in employee_big:
Elapsed time for "ALL SQL" = 83.92 seconds. Per repetition timing = .8392 seconds.
Elapsed time for "SOME PL/SQL" = 33.32 seconds. Per repetition timing = .3332 seconds.
*/
END;
/
