CONNECT SYSTEM/SYSTEM

DROP TABLE emp_thru_role;

CREATE TABLE emp_thru_role
(
   empno      NUMBER (4)
 , ename      VARCHAR2 (10)
 , job        VARCHAR2 (9)
 , mgr        NUMBER (4)
 , hiredate   DATE
 , sal        NUMBER (7, 2)
 , comm       NUMBER (7, 2)
 , deptno     NUMBER (2)
);

INSERT INTO emp_thru_role (empno, ename)
     VALUES (1000, 'BIG BOSS');

COMMIT;

DROP PUBLIC SYNONYM emp_thru_role;
CREATE PUBLIC SYNONYM emp_thru_role FOR emp_thru_role;

DROP ROLE invoker_scott_emp;
CREATE ROLE invoker_scott_emp NOT IDENTIFIED;

DROP ROLE invoker_system_emp;
CREATE ROLE invoker_system_emp NOT IDENTIFIED;

GRANT SELECT ON SYSTEM.emp_thru_role TO invoker_system_emp;

GRANT invoker_scott_emp TO hr WITH ADMIN OPTION;

GRANT invoker_system_emp TO hr WITH ADMIN OPTION;

CONNECT SCOTT/TIGER

DROP TABLE emp_thru_role;

CREATE TABLE emp_thru_role
AS
   SELECT * FROM emp;

GRANT SELECT ON emp_thru_role TO invoker_scott_emp;


CREATE OR REPLACE PROCEDURE showcount (use_schema_in IN BOOLEAN := FALSE)
   AUTHID CURRENT_USER
IS
   l_count   PLS_INTEGER;
BEGIN
   IF use_schema_in
   THEN
      SELECT COUNT (*) INTO l_count FROM scott.emp_thru_role;

      DBMS_OUTPUT.put_line ('count of scott.emp_thru_role = ' || l_count);
   ELSE
      SELECT COUNT (*) INTO l_count FROM emp_thru_role;

      DBMS_OUTPUT.put_line ('count of emp_thru_role = ' || l_count);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Error counting emp_thru_role = ' || SQLERRM);
END;
/

GRANT EXECUTE ON showcount TO demo;

CONNECT hr/hr
@@ssoo

DECLARE
   PROCEDURE setrole (role_in IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('Set role to ' || role_in);
      DBMS_SESSION.set_role (role_in);
   END;
BEGIN
   setrole ('invoker_system_emp');
   scott.showcount;
   scott.showcount (TRUE);

   DBMS_OUTPUT.put_line ('');

   setrole ('invoker_scott_emp');
   scott.showcount;
   scott.showcount (TRUE);
END;
/