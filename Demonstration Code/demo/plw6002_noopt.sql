ALTER SESSION SET plsql_warnings = 'enable:all'
/

ALTER SESSION SET plsql_optimize_level = 2
/

CREATE OR REPLACE PROCEDURE plw6002
AS
   l_checking BOOLEAN := FALSE;
BEGIN
   NULL;
   
   IF l_checking
   THEN
      DBMS_OUTPUT.put_line ('Never here...');
   END IF;
END plw6002;
/

SHOW ERRORS PROCEDURE plw6002

ALTER SESSION SET plsql_optimize_level = 1
/

ALTER PROCEDURE plw6002 COMPILE
/

SHOW ERRORS PROCEDURE plw6002

ALTER SESSION SET plsql_optimize_level = 0
/

ALTER PROCEDURE plw6002 COMPILE
/

SHOW ERRORS PROCEDURE plw6002

ALTER SESSION SET plsql_optimize_level = 2
/
