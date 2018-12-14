ALTER SESSION SET plsql_warnings = 'enable:all'
/

CREATE OR REPLACE PROCEDURE plw6017
   AUTHID CURRENT_USER
IS
   c   VARCHAR2 (1) := 'abc';
   n   NUMBER;
BEGIN
   n := 1 / 0;
END;
/

SHO ERR

/*

Notice it says that line 7 is unreachable.
Since line 4 raises an exception, line 7
will never be executed!

*/