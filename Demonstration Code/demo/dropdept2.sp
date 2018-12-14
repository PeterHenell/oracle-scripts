DROP TABLE dept2;
CREATE TABLE dept2 AS SELECT * FROM dept;
DROP TABLE emp2;
CREATE TABLE emp2 AS SELECT * FROM emp;

CREATE OR REPLACE PROCEDURE drop_dept
   (deptno_IN IN NUMBER, reassign_deptno_IN IN NUMBER)
IS
   temp_emp_count  NUMBER;
BEGIN
   register_app.MODULE
      (module_name_in => 'DEPARTMENT FIXES', action_name_in => 'CHECK EMP');
DBMS_LOCK.SLEEP (1);

   -- first check dept for employees
   SELECT COUNT(*) INTO temp_emp_count FROM emp2 WHERE deptno = deptno_IN;

   -- reassign any employees
   IF temp_emp_count >0
   THEN
      register_app.ACTION (action_name_in => 'REASSIGN EMPLOYEES');
DBMS_LOCK.SLEEP (1);

      UPDATE emp2 SET deptno = reassign_deptno_IN
       WHERE deptno = deptno_IN;
   END IF;

   register_app.ACTION (action_name_in => 'DROP DEPT');
DBMS_LOCK.SLEEP (1);

   DELETE FROM dept2 WHERE deptno = deptno_IN;

   COMMIT;

   register_app.MODULE(null,null);
DBMS_LOCK.SLEEP (1);

EXCEPTION
   WHEN OTHERS THEN
      register_app.MODULE (null,null);
END drop_dept;
/
