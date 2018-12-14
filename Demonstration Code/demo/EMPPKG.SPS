CREATE OR REPLACE PACKAGE emppkg
/*
|| Program: emppkg
||  Author: Steven Feuerstein
||    File: emppkg.spp
|| Created: February 10, 1997 09:49:07
*/
IS

/* Exceptions */

   no_such_employee EXCEPTION;
   multiple_primary_keys EXCEPTION;
   
/* Constants */

   c_updsal CONSTANT CHAR(2) := 'US';
   c_totcomp CONSTANT CHAR(2) := 'TC';
   c_showemp CONSTANT CHAR(2) := 'SE';

/* Cursors */

   CURSOR emp_cur (emp_in IN emp.empno%TYPE)
   IS
      SELECT ename, sal, totcomp (sal, comm) totalcomp, hiredate
        FROM emp
       WHERE empno = emp_in;
       
   CURSOR allemps_cur (deptno_in IN emp.deptno%TYPE DEFAULT NULL)
   IS
      SELECT ename, sal, comm,
             totcomp (sal, comm) totalcomp, hiredate
        FROM emp
       WHERE (deptno = deptno_in OR deptno_in IS NULL);
       
/* Programs */

   FUNCTION updating_salary (action_in IN VARCHAR2) RETURN BOOLEAN;
   FUNCTION setting_totalcomp (action_in IN VARCHAR2) RETURN BOOLEAN;
   FUNCTION showing_employee (action_in IN VARCHAR2) RETURN BOOLEAN;
   
   PROCEDURE updsal 
      (emp_in IN emp.empno%TYPE,
	   sal_in IN emp.sal%TYPE,
	   comm_in IN emp.comm%TYPE DEFAULT NULL);

END emppkg;
/
