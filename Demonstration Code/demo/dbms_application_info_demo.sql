DROP TABLE dept2;

CREATE TABLE dept2
AS
   SELECT * FROM dept;

DROP TABLE emp2;

CREATE TABLE emp2
AS
   SELECT * FROM emp;

CREATE OR REPLACE PROCEDURE drop_dept (
   deptno_in            IN NUMBER,
   reassign_deptno_in   IN NUMBER)
IS
   temp_emp_count   NUMBER;
BEGIN
   DBMS_APPLICATION_INFO.set_module (
      module_name   => 'DEPARTMENT FIXES',
      action_name   => 'CHECK EMP');
   DBMS_LOCK.sleep (10);

   -- first check dept for employees
   SELECT COUNT (*)
     INTO temp_emp_count
     FROM emp2
    WHERE deptno = deptno_in;

   -- reassign any employees
   IF temp_emp_count > 0
   THEN
      DBMS_APPLICATION_INFO.set_action (
         action_name => 'REASSIGN EMPLOYEES');
      DBMS_LOCK.sleep (10);

      UPDATE emp2
         SET deptno = reassign_deptno_in
       WHERE deptno = deptno_in;
   END IF;

   DBMS_APPLICATION_INFO.set_action (action_name => 'DROP DEPT');
   DBMS_LOCK.sleep (10);

   DELETE FROM dept2
         WHERE deptno = deptno_in;

   COMMIT;

   DBMS_APPLICATION_INFO.set_module (NULL, NULL);
   DBMS_LOCK.sleep (10);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_APPLICATION_INFO.set_module (NULL, NULL);
END drop_dept;
/