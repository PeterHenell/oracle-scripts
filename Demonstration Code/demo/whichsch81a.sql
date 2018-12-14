SET ECHO ON

SET FEEDBACK ON

SET VERIFY ON

SPOOL whichsch.log

CONNECT SCOTT/TIGER

CREATE OR REPLACE PROCEDURE showestack
IS
BEGIN
   p.l (RPAD ('=', 60, '='));
   p.l (DBMS_UTILITY.format_call_stack);
   p.l (RPAD ('=', 60, '='));
END;
/

REM Create reusable program containing dyn SQL as INVOKER RIGHTS

CREATE OR REPLACE PROCEDURE ir_runddl 
AUTHID CURRENT_USER
IS
   l_owner VARCHAR2(30);
BEGIN
   showestack;
   EXECUTE IMMEDIATE 'CREATE TABLE demo_table (col1 DATE)';
   SELECT OWNER into l_owner
     FROM ALL_OBJECTS
	WHERE OBJECT_NAME = 'DEMO_TABLE';
   DBMS_OUTPUT.PUT_LINE ('Owner of demo_table is ' || l_owner);
   EXECUTE IMMEDIATE 'DROP TABLE demo_table';
END;
/

CREATE OR REPLACE PROCEDURE dr_runddl 
IS
BEGIN
   ir_runddl;
END;
/

GRANT execute on ir_runddl to public;
GRANT execute on dr_runddl to public;

CONNECT demo/demo

CREATE OR REPLACE PROCEDURE ir_ir_runddl 
AUTHID CURRENT_USER
IS
BEGIN
   scott.ir_runddl ;
   DBMS_OUTPUT.PUT_LINE ('ir_ir_runddl success');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('ir_ir_runddl error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE dr_ir_runddl 
IS
BEGIN
   scott.ir_runddl ;
   DBMS_OUTPUT.PUT_LINE ('dr_ir_runddl success');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('dr_ir_runddl error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE ir_dr_runddl 
AUTHID CURRENT_USER
IS
BEGIN
   scott.dr_runddl ;
   DBMS_OUTPUT.PUT_LINE ('ir_dr_runddl success');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('ir_dr_runddl error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE dr_dr_runddl 
IS
BEGIN
   scott.dr_runddl ;
   DBMS_OUTPUT.PUT_LINE ('dr_dr_runddl success');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('dr_dr_runddl error: ' || SQLERRM);   
END;
/

DROP table demo_table;

DESC demo_table

@@ssoo

BEGIN
   ir_ir_runddl;
   ir_dr_runddl;
   dr_ir_runddl;
   dr_dr_runddl;
END;
/

REM Try adding super privs to DEMO.

CONNECT SYSTEM/MANAGER

GRANT CREATE TABLE TO DEMO;

CONNECT demo/demo

@@ssoo

BEGIN
   ir_ir_runddl;
   ir_dr_runddl;
   dr_ir_runddl;
   dr_dr_runddl;
END;
/

REM Try adding super privs only to SCOTT.

CONNECT SYSTEM/MANAGER

REVOKE CREATE TABLE FROM DEMO;
GRANT CREATE TABLE TO SCOTT;

CONNECT demo/demo

@@ssoo

BEGIN
   ir_ir_runddl;
   ir_dr_runddl;
   dr_ir_runddl;
   dr_dr_runddl;
END;
/


REM Try adding super privs to SCOTT and DEMO.

CONNECT SYSTEM/MANAGER

GRANT CREATE TABLE TO SCOTT;
GRANT CREATE TABLE TO DEMO;

CONNECT demo/demo

@@ssoo

BEGIN
   ir_ir_runddl;
   ir_dr_runddl;
   dr_ir_runddl;
   dr_dr_runddl;
END;
/

REM Revoke super privs.

CONNECT SYSTEM/MANAGER

REVOKE CREATE TABLE FROM DEMO;
REVOKE CREATE TABLE FROM SCOTT;

