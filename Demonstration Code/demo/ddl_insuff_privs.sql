spool dynddl.log

/* Don't let SCOTT create tables */

CONNECT sys/quest as sysdba

REVOKE RESOURCE FROM scott
/

REVOKE CREATE TABLE FROM scott
/

REVOKE create_table FROM scott
/

GRANT CREATE PROCEDURE TO scott
/

CONNECT scott/tiger

DROP TABLE can_do
/

DROP TABLE no_can_do
/

/* Cannot create tables either with "static" or 
   "dynamic" DDL */
   
CREATE TABLE can_do (n NUMBER)
/

BEGIN
   EXECUTE IMMEDIATE 'create table no_can_do (n number)';
END;
/

/* Grant create table privs through a role. */

CONNECT sys/quest as sysdba

REVOKE CREATE TABLE FROM scott
/

CREATE ROLE create_table
/

GRANT CREATE TABLE TO create_table
/

GRANT create_table TO scott
/

ALTER USER scott QUOTA 10m ON users
/

CONNECT scott/tiger

/* Can create a table statically, but not dynamically,
   via a stored program unit. */

CREATE TABLE can_do (n NUMBER)
/

BEGIN
   EXECUTE IMMEDIATE 'create table no_can_do (n number)';
END;
/

CREATE OR REPLACE PROCEDURE create_table_proc
AUTHID DEFINER
IS
BEGIN
   EXECUTE IMMEDIATE 'create table no_can_do2 (n number)';
END;
/

BEGIN
   create_table_proc ();
END;
/

/* Now try with invoker rights */

CREATE OR REPLACE PROCEDURE create_table_proc
AUTHID CURRENT_USER
IS
BEGIN
   EXECUTE IMMEDIATE 'create table no_can_do2 (n number)';
END;
/

BEGIN
   create_table_proc ();
END;
/

CONNECT sys/quest as sysdba

GRANT CREATE TABLE TO scott
/

CONNECT scott/tiger

/* Now create table through a stored program unit. */

DROP TABLE can_do
/

CREATE OR REPLACE PROCEDURE create_table_proc
AUTHID DEFINER
IS
BEGIN
   EXECUTE IMMEDIATE 'create table can_do (n number)';
END;
/

BEGIN
   create_table_proc ();
END;
/

SPOOL OFF