SET FEEDBACK ON
SET ECHO ON

ALTER SESSION SET plsql_warnings = 'enable:all'
/

CREATE OR REPLACE PROCEDURE plw6007
   AUTHID DEFINER
AS
   l_var   NUMBER;

   PROCEDURE not_used
   IS
   BEGIN
      NULL;
   END not_used;
BEGIN
   DBMS_OUTPUT.put_line (l_var);
END plw6007;
/

SHOW ERRORS FUNCTION plw6007

dbms_utility