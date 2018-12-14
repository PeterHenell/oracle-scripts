SET FEEDBACK ON
SET ECHO ON

ALTER SESSION SET plsql_warnings = 'enable:all'
/

CREATE OR REPLACE PROCEDURE plw7206
   AUTHID DEFINER
AS
   l_var1   CHAR (1) := 'abc';
   l_var2   VARCHAR2 (1) := 'abc';
   l_var3   NUMBER := 1 / 0;
BEGIN
   NULL;
END plw7206;
/

SHOW ERRORS PROCEDURE plw7206