SET FEEDBACK ON
SET ECHO ON

ALTER SESSION SET plsql_warnings = 'enable:6009'
/

/*
Only a RETURN in an exception section. Warning issued.
*/

CREATE OR REPLACE FUNCTION plw6009
   RETURN VARCHAR2
AS
BEGIN
   RETURN 'abc';
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN 'abc';
END plw6009;
/

SHOW ERRORS FUNCTION plw6009

/* WIth a RAISE, no warning issued. */

CREATE OR REPLACE FUNCTION plw6009
   RETURN VARCHAR2
AS
BEGIN
   RETURN 'abc';
EXCEPTION
   WHEN OTHERS
   THEN
      RAISE;
END plw6009;
/

SHOW ERRORS FUNCTION plw6009

/* WIth a RAISE_APPLICATION_ERROR, no warning issued. */

CREATE OR REPLACE FUNCTION plw6009
   RETURN VARCHAR2
AS
BEGIN
   RETURN 'abc';
EXCEPTION
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR (-20000, 'I am raising an exception!');
      RETURN 'abc';
END plw6009;
/

SHOW ERRORS FUNCTION plw6009

/* "Hide" the RAISE inside a generic utility and the 
   compiler still raises the warning. */
   
CREATE OR REPLACE PROCEDURE raise_in_here
AS
BEGIN
   RAISE PROGRAM_ERROR;
END raise_in_here;
/

CREATE OR REPLACE FUNCTION plw6009
   RETURN VARCHAR2
AS
BEGIN
   RETURN 'abc';
EXCEPTION
   WHEN OTHERS
   THEN
      raise_in_here;
      RETURN NULL;
END plw6009;
/

SHOW ERRORS FUNCTION plw6009

/* But if I take away the RETURN then I do get the warning:
   Oracle assumes that the execution of the function WILL
   raise an error - one it's own, that the function does
   not return a value! 
*/
   
CREATE OR REPLACE FUNCTION plw6009
   RETURN VARCHAR2
AS
BEGIN
   RETURN 'abc';
EXCEPTION
   WHEN OTHERS
   THEN
      raise_in_here;
END plw6009;
/
