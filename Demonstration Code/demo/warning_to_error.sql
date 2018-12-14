ALTER SESSION SET plsql_warnings = 'enable:all'
/

CREATE OR REPLACE PROCEDURE proc
IS
   b   CONSTANT BOOLEAN := TRUE;
BEGIN
   IF b
   THEN
      DBMS_OUTPUT.put_line ('b true');
   END IF;

   DBMS_OUTPUT.put_line ('done');
END proc;
/

alter procedure proc compile plsql_warnings = 'error:6002' reuse settings
/