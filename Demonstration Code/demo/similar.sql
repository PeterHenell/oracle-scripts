CREATE OR REPLACE PROCEDURE abc
IS
   rec       emp%ROWTYPE;
   v_dept    INTEGER := 10;
   v_name    VARCHAR2 (100) := 'S%';
   v_dept2   INTEGER := 10;
   v_name2   VARCHAR2 (100) := 'S%';
BEGIN
   FOR rec IN (select ename, sal
                 from emp
                where deptno = v_dept 
                  and ename like v_name)
   LOOP
      NULL;
   END LOOP;

   FOR rec IN (SELECT ename, sal
                 FROM emp
                WHERE ename LIKE 'S%' AND deptno = 10)
   LOOP
      NULL;
   END LOOP;

   FOR rec IN (SELECT ename, sal
                 FROM emp
                WHERE deptno = v_dept2 AND ename LIKE v_name2)
   LOOP
      NULL;
   END LOOP;
END;
/

DECLARE
   CURSOR x
   IS
      SELECT * FROM emp;
BEGIN
   p.l (1);
END;
/

DECLARE
   CURSOR x
   IS
      SELECT * FROM emp;
BEGIN
   p.l (1);
END;
/

REM We DO NOT want to see all the output.
SET SERVEROUTPUT OFF

@showemps.sp

BEGIN
   showemps;
END;
/

BEGIN
   showemps;
   NULL;
END;
/

BEGIN
   showemps (where_in => 'department_id = 10');
END;
/

@@ssoo

BEGIN
   /* Narrowest search for similar SQL */
   insga.show_similar;

   /* Check for similarities for all strings containing emp
      and only compare the first 20 characters. */
   insga.show_similar (
      '%emp%',
      stopat   => 20,
      title    => ' Text like "%emp%", stopping at position 20');


   /* Show all the SQL Text that contains the emp word */
   insga.show_sqltext ('%emp%');
END;
/