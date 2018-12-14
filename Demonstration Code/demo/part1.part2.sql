/*

Which of the choices describe definitions for plch_part1 and plch_part2
so that the following block with display "Made it this far"
after it is executed from the HR schema?

DECLARE
   my_list   plch_part1.plch_part2 := plch_part1.plch_part2 ();
BEGIN
   my_list.EXTEND;
   my_list (1) := 'Made it this far';
   DBMS_OUTPUT.put_line (my_list(1));
END;
/

*/

/* 

A schema named plch_part1 is created.
A nested table type of VARCHAR2(100) named plch_part2 is created in plch_part1.
EXECUTE on plch_part2 is granted to HR.

*/

SPOOL plch.log

CONNECT Sys/pwd AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE create_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      /* Grant required privileges...*/
      EXECUTE IMMEDIATE
            'grant Create Session, Resource to '
         || user_in
         || ' identified by '
         || user_in;

      DBMS_OUTPUT.put_line ('User "' || user_in || '" was created.');
   END create_user;
BEGIN
   create_user ('plch_part1');
/* Any additional grants.... */
END;
/

CONNECT plch_part1/plch_part1

CREATE TYPE plch_part2 IS TABLE OF VARCHAR2 (100)
/

GRANT EXECUTE ON plch_part2 TO hr
/

CONNECT hr/hr

SET SERVEROUTPUT ON

DECLARE
   my_list   plch_part1.plch_part2 := plch_part1.plch_part2 ();
BEGIN
   my_list.EXTEND;
   my_list (1) := 'Made it this far';
   DBMS_OUTPUT.put_line ('Schema plch_part1 Table plch_part2 Execute grant');
   DBMS_OUTPUT.put_line (my_list (1));
END;
/

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE drop_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;
   END;
BEGIN
   drop_user ('plch_part1');
END;
/

/* 

A package named plch_part1 is created in HR, which contains
A nested table type of VARCHAR2(100) named plch_part2.

*/

CONNECT hr/hr

SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE plch_part1
IS
   TYPE plch_part2 IS TABLE OF VARCHAR2 (100);
END;
/

DECLARE
   my_list   plch_part1.plch_part2 := plch_part1.plch_part2 ();
BEGIN
   my_list.EXTEND;
   my_list (1) := 'Made it this far';
   DBMS_OUTPUT.put_line ('Package in HR');
   DBMS_OUTPUT.put_line (my_list (1));
END;
/

DROP PACKAGE plch_part1
/

/* 

A schema named plch_new_schema is created.
A package named plch_part1 is created in plch_new_schema, which contains
A nested table type of VARCHAR2(100) named plch_part2.
EXECUTE on plch_part1 is granted to HR.

*/

CONNECT Sys/pwd AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE create_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      /* Grant required privileges...*/
      EXECUTE IMMEDIATE
            'grant Create Session, Resource to '
         || user_in
         || ' identified by '
         || user_in;

      DBMS_OUTPUT.put_line ('User "' || user_in || '" was created.');
   END create_user;
BEGIN
   create_user ('plch_new_schema');
/* Any additional grants.... */
END;
/

CONNECT plch_new_schema/plch_new_schema

CREATE OR REPLACE PACKAGE plch_part1
IS
   TYPE plch_part2 IS TABLE OF VARCHAR2 (100);
END;
/

GRANT EXECUTE ON plch_part1 TO hr
/

CONNECT hr/hr

SET SERVEROUTPUT ON

DECLARE
   my_list   plch_part1.plch_part2 := plch_part1.plch_part2 ();
BEGIN
   my_list.EXTEND;
   my_list (1) := 'Made it this far';
   DBMS_OUTPUT.put_line ('Package in HR');
   DBMS_OUTPUT.put_line (my_list (1));
END;
/

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE drop_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;
   END;
BEGIN
   drop_user ('plch_new_schema');
END;
/

/* 

A schema named plch_new_schema is created.
A package named plch_part1 is created in plch_new_schema, which contains
A nested table type of VARCHAR2(100) named plch_part2.
EXECUTE on plch_part1 is granted to HR.
A synonym named plch_part1 for plch_new_schema.plch_part1 is created in HR.

*/

CONNECT Sys/pwd AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE create_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      /* Grant required privileges...*/
      EXECUTE IMMEDIATE
            'grant Create Session, Resource to '
         || user_in
         || ' identified by '
         || user_in;

      DBMS_OUTPUT.put_line ('User "' || user_in || '" was created.');
   END create_user;
BEGIN
   create_user ('plch_new_schema');
/* Any additional grants.... */
END;
/

CONNECT plch_new_schema/plch_new_schema

CREATE OR REPLACE PACKAGE plch_part1
IS
   TYPE plch_part2 IS TABLE OF VARCHAR2 (100);
END;
/

GRANT EXECUTE ON plch_part1 TO hr
/

CONNECT hr/hr

SET SERVEROUTPUT ON

CREATE SYNONYM plch_part1 FOR plch_new_schema.plch_part1
/

DECLARE
   my_list   plch_part1.plch_part2 := plch_part1.plch_part2 ();
BEGIN
   my_list.EXTEND;
   my_list (1) := 'Made it this far';
   DBMS_OUTPUT.put_line ('Package in HR');
   DBMS_OUTPUT.put_line (my_list (1));
END;
/

DECLARE
   user_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE drop_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;
   END;
BEGIN
   drop_user ('plch_new_schema');
END;
/

SPOOL OFF