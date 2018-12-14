CONNECT scott/tiger

@exec_ddl_from_file2.sql

CREATE OR REPLACE PROCEDURE exec_ddl
IS
BEGIN
   exec_ddl_from_file ( 'TEMP', 'exec_ddl.tst' );
END exec_ddl;
/

GRANT EXECUTE ON exec_ddl_from_file TO hr;
GRANT EXECUTE ON exec_ddl TO hr;

CONNECT hr/hr
set serveroutput on

DROP table exec_ddl_table
/

EXEC scott.exec_ddl_from_file ('TEMP', 'exec_ddl.tst');

exec scott.exec_ddl
