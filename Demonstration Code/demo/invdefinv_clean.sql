/*
Demonstrate the effect of AUTHID CURRENT_USER
and also the fact that as soon as you come across
a definer rights program in the call stack, any
subsequent invoker rights programs resolve
CURRENT_USER back to the owner of the definer rights
program.
*/

/* The Scott schema's table has 2 rows. */
CONNECT scott/tiger

CREATE TABLE authid_demo (n NUMBER)
/

BEGIN
   INSERT INTO authid_demo
   VALUES (1);

   INSERT INTO authid_demo
   VALUES (2);

   COMMIT;
END;
/

/* The HR schema's table table has 0 rows. */
CONNECT hr/hr

CREATE TABLE authid_demo (n NUMBER)
/

CONNECT scott/tiger

/*
Helper program that shows the execution call stack:
How did I get here?
*/

CREATE OR REPLACE PROCEDURE proc1
   AUTHID CURRENT_USER
IS
   num   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO num
     FROM authid_demo;

   DBMS_OUTPUT.put_line ('proc 1 invoker authid_demo count = ' || num);
END;
/

CREATE OR REPLACE PROCEDURE proc2
   AUTHID DEFINER
IS
   num   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO num
     FROM authid_demo;

   DBMS_OUTPUT.put_line ('proc 2 definer authid_demo count = ' || num);
   proc1;
END;
/

CREATE OR REPLACE PROCEDURE proc3
   AUTHID CURRENT_USER
IS
   num   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO num
     FROM authid_demo;

   DBMS_OUTPUT.put_line ('proc 3 invoker authid_demo count = ' || num);
   proc1;
   proc2;
END;
/

GRANT EXECUTE ON proc1 TO hr
/

GRANT EXECUTE ON proc2 TO hr
/

GRANT EXECUTE ON proc3 TO hr
/

GRANT SELECT ON scott.authid_demo TO hr
/

CONNECT hr/hr

SET SERVEROUTPUT ON FORMAT WRAPPED

/* Notice how the count in authid_demo changes for HR in the two calls, from 0 to 14. */

BEGIN
   scott.proc3;
END;
/