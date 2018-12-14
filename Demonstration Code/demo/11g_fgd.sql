DROP TABLE employees_11g_fgd
/

CREATE TABLE employees_11g_fgd
AS
   SELECT *
     FROM employees
/

CREATE OR REPLACE PROCEDURE show_proc_validity (
   change_in    IN VARCHAR2
 , owner_in     IN VARCHAR2
 , NAME_IN      IN VARCHAR2
 , recompile_in IN BOOLEAN DEFAULT TRUE
)
IS
   l_validity   all_objects.status%TYPE;
BEGIN
   SELECT status
     INTO l_validity
     FROM all_objects
    WHERE     owner = owner_in
          AND object_name = NAME_IN
          AND object_type = 'PROCEDURE';

   DBMS_OUTPUT.put_line ('After "' || change_in || '"');
   DBMS_OUTPUT.
    put_line (
      '   State of ' || owner_in || '.' || NAME_IN || ' = ' || l_validity
   );
   DBMS_OUTPUT.put_line ('.');

   IF l_validity = 'INVALID' AND recompile_in
   THEN
      EXECUTE IMMEDIATE   'alter procedure '
                       || owner_in
                       || '.'
                       || NAME_IN
                       || ' COMPILE REUSE SETTINGS';
   END IF;
END show_proc_validity;
/

CREATE OR REPLACE PACKAGE pkg1
IS
   PROCEDURE proc1 (a IN VARCHAR2);

   FUNCTION func1
      RETURN VARCHAR2;
END pkg1;
/

CREATE OR REPLACE PROCEDURE use_pkg1
IS
   l_name   employees_11g_fgd.last_name%TYPE;
BEGIN
   SELECT e.last_name
     INTO l_name
     FROM employees_11g_fgd e
    WHERE e.employee_id = 198;

   pkg1.proc1 ('a');
END use_pkg1;
/

BEGIN
   show_proc_validity ('Freshly Compiled', USER, 'USE_PKG1');
END;
/

/* Change size of first_name column - validity should be VALID. */

ALTER TABLE employees_11g_fgd MODIFY first_name VARCHAR2(2000)
/

BEGIN
   DBMS_OUTPUT.
    put_line ('Change size of first_name column - state should remain VALID.'
             );
   show_proc_validity ('Change LAST_NAME Column', USER, 'USE_PKG1');
END;
/

/* Add a new function - should not affect state. */

CREATE OR REPLACE PACKAGE pkg1
IS
   PROCEDURE proc1 (a IN VARCHAR2);

   FUNCTION func1
      RETURN VARCHAR2;

   FUNCTION func2
      RETURN NUMBER;
END pkg1;
/

BEGIN
   DBMS_OUTPUT.put_line ('Add a new function - should not affect state.');
   show_proc_validity ('Add new function', USER, 'USE_PKG1');
END;
/

/* Add column to employees_11g_fgd; should not affect state. */

ALTER TABLE employees_11g_fgd ADD nickname VARCHAR2(100)
/

BEGIN
   DBMS_OUTPUT.
    put_line ('Add column to employees_11g_fgd; should not affect state.');
   show_proc_validity ('Add new column', USER, 'USE_PKG1');
END;
/

ALTER TABLE employees_11g_fgd DROP COLUMN nickname
/

/* Add new IN parameter with trailing default */

CREATE OR REPLACE PACKAGE pkg1
IS
   PROCEDURE proc1 (a IN VARCHAR2, b IN PLS_INTEGER DEFAULT NULL);

   FUNCTION func1
      RETURN VARCHAR2;

   FUNCTION func2
      RETURN NUMBER;
END pkg1;
/

BEGIN
   DBMS_OUTPUT.
    put_line (
      'Add new IN parameter with trailing default - should not affect state? It does!'
   );
   show_proc_validity ('Add new parameter', USER, 'USE_PKG1');
END;
/

/* Change datatype of argument that is used; should affect state. */

CREATE OR REPLACE PACKAGE pkg1
IS
   PROCEDURE proc1 (a IN DATE);

   FUNCTION func1
      RETURN VARCHAR2;

   FUNCTION func2
      RETURN NUMBER;
END pkg1;
/

BEGIN
   DBMS_OUTPUT.
    put_line (
      'Change datatype of argument that is used; should affect state.'
   );
   show_proc_validity ('Change parameter type to DATE', USER, 'USE_PKG1');
END;
/

set serveroutput on format wrapped

CREATE OR REPLACE PROCEDURE show_validity (s     IN VARCHAR2
                                         , n     IN VARCHAR2
                                         , t     IN VARCHAR2
                                         , title IN VARCHAR2 DEFAULT NULL
                                          )
IS
   l_validity   all_objects.status%TYPE;
BEGIN
   SELECT status
     INTO l_validity
     FROM all_objects
    WHERE owner = s AND object_name = n AND object_type = t;

   DBMS_OUTPUT.put_line ('validity of ' || t || ' ' || s || '.' || n);

   IF title IS NOT NULL
   THEN
      DBMS_OUTPUT.put_line (title);
   END IF;

   DBMS_OUTPUT.put_line (l_validity);
END show_validity;
/

CREATE OR REPLACE PACKAGE magic_value
IS
   c_value1   NUMBER := 1;
END;
/

CREATE OR REPLACE PROCEDURE use_magic_value
IS
BEGIN
   DBMS_OUTPUT.put_line (magic_value.c_value1);
END;
/

BEGIN
   show_validity (USER, 'USE_MAGIC_VALUE', 'PROCEDURE', 'Initial Compile');
END;
/

CREATE OR REPLACE PACKAGE magic_value
IS
   c_value1   NUMBER := 2;
END;
/

BEGIN
   show_validity (USER
                , 'USE_MAGIC_VALUE'
                , 'PROCEDURE'
                , 'Change packaged constant value'
                 );
END;
/

/*
Connected to Oracle Database 10g Enterprise Edition Release 10.2.0.1.0
Connected as patrick
SQL>
Procedure created
Package created
Procedure created
validity of PROCEDURE PATRICK.USE_MAGIC_VALUE
Initial Compile
VALID
PL/SQL procedure successfully completed
Package created
Validity of PROCEDURE PATRICK.USE_MAGIC_VALUE
Change packaged constant value
INVALID
*/