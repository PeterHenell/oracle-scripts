/*
Demonstrate the effect of AUTHID CURRENT_USER
and also the fact that as soon as you come across
a definer rights program in the call stack, any
subsequent invoker rights programs resolve
CURRENT_USER back to the owner of the definer rights
program.
*/

/* The HR schema's EMP table has 0 rows. */

CONNECT scott/scott

SELECT COUNT (*)
  FROM emp
/
/* The HR schema's EMP table has 0 rows. */

CONNECT hr/hr

SELECT COUNT (*)
  FROM emp
/

CONNECT scott/scott

/*
Helper program that shows the execution call stack:
How did I get here?
*/

CREATE OR REPLACE PROCEDURE showestack
-- invdefinv.sql
IS
BEGIN
   DBMS_OUTPUT.put_line (RPAD ('=', 60, '='));
   DBMS_OUTPUT.put_line (DBMS_UTILITY.format_call_stack);
   DBMS_OUTPUT.put_line (RPAD ('=', 60, '='));
END;
/

/* 
Helper program that shows whether or not a definer rights
program has been encountered somewhere along the call stack.
*/

CREATE OR REPLACE FUNCTION invoker_rights_mode
   RETURN BOOLEAN AUTHID CURRENT_USER
IS
   -- Created by Solomon Yakobson
BEGIN
   RETURN SYS_CONTEXT ('USERENV', 'SESSION_USER') =
          SYS_CONTEXT ('USERENV', 'CURRENT_USER');

END invoker_rights_mode;
/

CREATE OR REPLACE PROCEDURE proc1
AUTHID CURRENT_USER
IS
   num   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO num
     FROM emp;

   showestack;
   p.l ('proc 1 invoker emp count', num);
   p.l ('Invoker rights?', invoker_rights_mode (), show_in => TRUE);
END;
/

GRANT EXECUTE ON proc1 TO hr;

CREATE OR REPLACE PROCEDURE proc2
AUTHID DEFINER
IS
   num   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO num
     FROM emp;

   showestack;
   p.l ('proc 2 definer emp count', num);
   p.l ('Invoker rights?', invoker_rights_mode (), show_in => TRUE);
   proc1;
END;
/

GRANT EXECUTE ON proc2 TO hr;

CREATE OR REPLACE PROCEDURE proc3
AUTHID CURRENT_USER
IS
   num   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO num
     FROM emp;

   showestack;
   p.l ('proc 3 invoker emp count', num);
   p.l ('Invoker rights?', invoker_rights_mode (), show_in => TRUE);
   proc1;
   proc2;
END;
/

GRANT EXECUTE ON proc3 TO hr;
GRANT EXECUTE ON proc1 TO hr;
GRANT SELECT ON scott.emp TO hr;

/*
Raise an error if somewhere along the way, a definer rights
program was encountered...
*/

CREATE OR REPLACE PROCEDURE proc1
AUTHID CURRENT_USER
IS
   num   PLS_INTEGER;
BEGIN
   assert.is_true (invoker_rights_mode ()
                 , 'Proc1 is NOT running in invoker rights mode!'
                  );

   SELECT COUNT (*)
     INTO num
     FROM emp;

   showestack;
   p.l ('proc 1 invoker emp count', num);
   p.l ('Invoker rights?', invoker_rights_mode (), show_in => TRUE);
END;
/