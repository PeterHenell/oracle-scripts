/*
For this to work properly, HR should not have the create table privilege
when the script starts.
*/

SET ECHO ON
SET FEEDBACK ON
SET VERIFY ON

SPOOL whichsch.log

CONNECT system/quest

GRANT CREATE TABLE TO HR
/

CONNECT scott/tiger

DROP TABLE demo_data
/

CREATE TABLE demo_data (n NUMBER)
/

BEGIN
   INSERT INTO demo_data
        VALUES (1);

   COMMIT;
END;
/

REM Create reusable program containing dyn SQL as INVOKER RIGHTS

CREATE OR REPLACE PROCEDURE ir_runddl
   AUTHID CURRENT_USER
IS
   l_owner    VARCHAR2 (30);
   l_number   NUMBER;
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE DEMO_TABLE (col1 DATE)';

   SELECT owner
     INTO l_owner
     FROM all_objects
    WHERE object_name = 'DEMO_TABLE';

   DBMS_OUTPUT.put_line (
      '==>Successfully created ' || ' ' || l_owner || '.DEMO_TABLE');

   EXECUTE IMMEDIATE 'DROP TABLE DEMO_TABLE';

   SELECT n INTO l_number FROM demo_data;

   DBMS_OUTPUT.put_line ('DEMO_DATA=' || l_number);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('==>Failed to create DEMO_TABLE');
      DBMS_OUTPUT.put_line ('   Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE dr_runddl
-- Overrides invoker with definer rights
IS
BEGIN
   ir_runddl;
END;
/

GRANT EXECUTE ON ir_runddl TO PUBLIC;


GRANT EXECUTE ON dr_runddl TO PUBLIC;


CONNECT hr/hr

DROP TABLE demo_data
/

CREATE TABLE demo_data (n NUMBER)
/

BEGIN
   INSERT INTO demo_data
        VALUES (2);

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE ir_ir_runddl
   AUTHID CURRENT_USER
IS
BEGIN
   DBMS_OUTPUT.put_line ('HR Invoker SCOTT Invoker');
   scott.ir_runddl;
END;
/

CREATE OR REPLACE PROCEDURE dr_ir_runddl
IS
BEGIN
   DBMS_OUTPUT.put_line ('HR Definer SCOTT Invoker');
   scott.ir_runddl;
END;
/

CREATE OR REPLACE PROCEDURE ir_dr_runddl
   AUTHID CURRENT_USER
IS
BEGIN
   DBMS_OUTPUT.put_line ('HR Invoker SCOTT Definer');
   scott.dr_runddl;
END;
/

CREATE OR REPLACE PROCEDURE dr_dr_runddl
IS
BEGIN
   DBMS_OUTPUT.put_line ('HR Definer SCOTT Definer');
   scott.dr_runddl;
END;
/

DROP TABLE demo_table;

DESC DEMO_TABLE

SET FEEDBACK OFF

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line ('Without explicit create table priv for hr.');
   ir_ir_runddl;
   ir_dr_runddl;
   dr_ir_runddl;
   dr_dr_runddl;
END;
/

REM Try adding super privs to hr.

CONNECT SYSTEM/quest
SET FEEDBACK OFF
GRANT CREATE TABLE TO hr;

CONNECT hr/hr
SET FEEDBACK OFF

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line ('Added explicit create table priv only to hr.');
   ir_ir_runddl;
   ir_dr_runddl;
   dr_ir_runddl;
   dr_dr_runddl;
END;
/

REM Try adding super privs only to SCOTT.

CONNECT SYSTEM/quest
SET FEEDBACK OFF
REVOKE CREATE TABLE FROM hr;
GRANT CREATE TABLE TO scott;

CONNECT hr/hr
SET FEEDBACK OFF

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line ('Added explicit create table priv only to SCOTT.');
   ir_ir_runddl;
   ir_dr_runddl;
   dr_ir_runddl;
   dr_dr_runddl;
END;
/

SPOOL OFF