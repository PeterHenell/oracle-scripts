DECLARE
   TYPE cursors_t IS VARRAY (10) OF SYS_REFCURSOR;

   l_cursors   cursors_t;
BEGIN
   NULL;
END;
/

DECLARE
   TYPE exceptions_t IS VARRAY (10) OF exception;

   l_exceptions   exceptions_t;
BEGIN
   NULL;
END;
/

/* Schema level type cannot reference PL/SQL types. */

CREATE OR REPLACE TYPE boolean_nt IS VARRAY (10) OF BOOLEAN
/

SHO ERR

CREATE OR REPLACE TYPE record_nt IS VARRAY (10) OF employees%ROWTYPE
/

SHO ERR