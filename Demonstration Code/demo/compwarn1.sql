ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:ALL';

CREATE OR REPLACE PROCEDURE cant_go_there
AS
   l_salary NUMBER := 10000;
BEGIN
   IF l_salary > 20000
   THEN
      dbms_output.put_line ('Executive');
   ELSE
      dbms_output.put_line ('Rest of Us');
   END IF;
END cant_go_there;
/

SHOW ERRORS

SHOW ERRORS PROCEDURE cant_go_there;

REM Try it with strings

CREATE OR REPLACE PROCEDURE cant_go_there
AS
   x VARCHAR2(100) := '10';
BEGIN
   IF x = '10'
   THEN
      x := '20';
   ELSE
      x := '100';                     
   END IF;
END cant_go_there;
/

SHOW ERRORS PROCEDURE cant_go_there;

REM Try it with Booleans

CREATE OR REPLACE PROCEDURE cant_go_there
AS
   x boolean := true;
BEGIN
   IF x 
   THEN
      x := true;
   ELSE
      x := false;                     
   END IF;
END cant_go_there;
/

SHOW ERRORS PROCEDURE cant_go_there;

