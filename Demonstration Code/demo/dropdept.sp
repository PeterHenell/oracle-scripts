DROP TABLE dept2;
CREATE TABLE dept2 AS SELECT * FROM dept;
DROP TABLE emp2;
CREATE TABLE emp2 AS SELECT * FROM emp;

CREATE OR REPLACE PROCEDURE drop_dept
   (deptno_IN IN NUMBER, reassign_deptno_IN IN NUMBER)
IS
   temp_emp_count  NUMBER;
BEGIN
   DBMS_APPLICATION_INFO.SET_MODULE
      (module_name => 'DEPARTMENT FIXES', action_name => 'CHECK EMP');
DBMS_LOCK.SLEEP (10);

   -- first check dept for employees
   SELECT COUNT(*) INTO temp_emp_count FROM emp2 WHERE deptno = deptno_IN;

   -- reassign any employees 
   IF temp_emp_count >0
   THEN
      DBMS_APPLICATION_INFO.SET_ACTION (action_name => 'REASSIGN EMPLOYEES');
DBMS_LOCK.SLEEP (10);
   
      UPDATE emp2 SET deptno = reassign_deptno_IN
       WHERE deptno = deptno_IN;
   END IF;

   DBMS_APPLICATION_INFO.SET_ACTION (action_name => 'DROP DEPT');
DBMS_LOCK.SLEEP (10);

   DELETE FROM dept2 WHERE deptno = deptno_IN;

   COMMIT;

   DBMS_APPLICATION_INFO.SET_MODULE(null,null);
DBMS_LOCK.SLEEP (10);

EXCEPTION
   WHEN OTHERS THEN
      DBMS_APPLICATION_INFO.SET_MODULE (null,null);
END drop_dept;
/
