ALTER SESSION SET plsql_warnings = 'enable:all'
/

CREATE OR REPLACE FUNCTION my_function
   RETURN BOOLEAN
IS
BEGIN
   RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION my_date
   RETURN DATE
IS
BEGIN
   RETURN SYSDATE - 10;
END;
/

CREATE OR REPLACE FUNCTION no_return (check_in IN BOOLEAN)
   RETURN VARCHAR2
AS
BEGIN
   IF check_in
   THEN
      RETURN 'abc';
   ELSE
      DBMS_OUTPUT.put_line ('Here I am, here I stay');

      IF my_function ()                                          -- who knows?
      THEN
         RETURN 'def';
      ELSIF SYSDATE < my_date ()
      THEN
         RETURN 'qrs';
      ELSE
         DBMS_OUTPUT.put_line ('Hello!');
      END IF;
   END IF;
END no_return;
/

BEGIN
   DBMS_OUTPUT.put_line (no_return (FALSE));
END;
/

SHOW ERRORS FUNCTION no_return

ALTER SESSION SET plsql_warnings = 'ERROR:5005'
/

ALTER FUNCTION no_return COMPILE
/
SHOW ERRORS FUNCTION no_return

CREATE OR REPLACE FUNCTION no_return (check_in IN BOOLEAN)
   RETURN VARCHAR2
AS
BEGIN
   IF check_in
   THEN
      RETURN 'abc';
   ELSE
      DBMS_OUTPUT.put_line ('Here I am, here I stay');

      IF check_in
      THEN
         RETURN 'def';
      ELSIF SYSDATE IS NOT NULL
      THEN
         RETURN 'qrs';
      ELSE
         DBMS_OUTPUT.put_line ('Hello!');
         RETURN 'hello';
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END no_return;
/

SHOW ERRORS FUNCTION no_return

CREATE OR REPLACE FUNCTION no_return (check_in IN BOOLEAN)
   RETURN VARCHAR2
AS
BEGIN
   RETURN NULL;
EXCEPTION
   WHEN OTHERS
   THEN
      RAISE NO_DATA_FOUND;
END no_return;
/

SHOW ERRORS FUNCTION no_return

/* Not smart enough to know that raise_application_error 
   raises an exception! */

CREATE OR REPLACE FUNCTION error5005
   RETURN INTEGER
IS
BEGIN
   RETURN 5;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20001, 'Error 5005');
END;
/

CALL DBMS_WARNING.set_warning_setting_string ('ERROR:5005', 'SESSION')
/

ALTER FUNCTION error5005 COMPILE
/

SHO ERR

/* Rewriting the function to avoid the problem:
   One way in, one way out
*/

CREATE OR REPLACE FUNCTION no_return (check_in IN BOOLEAN)
   RETURN VARCHAR2
AS
   l_return   VARCHAR2 (32767);
BEGIN
   IF check_in
   THEN
      l_return := 'abc';
   ELSE
      DBMS_OUTPUT.put_line ('Here I am, here I stay');

      IF check_in
      THEN
         l_return := 'def';
      ELSIF SYSDATE IS NOT NULL
      THEN
         l_return := 'qrs';
      ELSE
         DBMS_OUTPUT.put_line ('Hello!');
         l_return := 'hello';
      END IF;
   END IF;

   RETURN l_return;
EXCEPTION
   WHEN OTHERS
   THEN
      log_error ();
      RAISE;
END no_return;
/