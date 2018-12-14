CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist exception;
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
      EXECUTE IMMEDIATE   'grant Create Session, Resource to '
                       || user_in
                       || ' identified by '
                       || user_in;

      DBMS_OUTPUT.put_line ('User "' || user_in || '" was created.');
   END create_user;
BEGIN
   create_user ('user_one');
   create_user ('user_two');
END;
/

connect user_one/user_one

DECLARE
   /*
   Demonstrate that changing the current schema does not affect
   the session and current users.
   */
   PROCEDURE show_users
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         'Session user = ' || SYS_CONTEXT ('USERENV', 'SESSION_USER')
      );
      DBMS_OUTPUT.put_line (
         'Current user = ' || SYS_CONTEXT ('USERENV', 'CURRENT_USER')
      );
   END;
BEGIN
   show_users;

   EXECUTE IMMEDIATE 'alter session set current_schema = USER_TWO';

   show_users;
/*
Session user = USER_ONE
Current user = USER_ONE
Session user = USER_ONE
Current user = USER_ONE
*/
END;
/

/*
Show how current user can change from session user with definer rights.
*/

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE proc_one
AUTHID CURRENT_USER
IS
   PROCEDURE show_users
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         'Session user = ' || SYS_CONTEXT ('USERENV', 'SESSION_USER')
      );
      DBMS_OUTPUT.put_line (
         'Current user = ' || SYS_CONTEXT ('USERENV', 'CURRENT_USER')
      );
   END;
BEGIN
   DBMS_OUTPUT.put_line ('PROC_ONE - INVOKER RIGHTS');
   show_users ();
END;
/

BEGIN
   proc_one;
END;
/

GRANT EXECUTE ON proc_one TO user_two
/

connect user_two/user_two

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE proc_two
AUTHID DEFINER
IS
   PROCEDURE show_users
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         'Session user = ' || SYS_CONTEXT ('USERENV', 'SESSION_USER')
      );
      DBMS_OUTPUT.put_line (
         'Current user = ' || SYS_CONTEXT ('USERENV', 'CURRENT_USER')
      );
   END;
BEGIN
   DBMS_OUTPUT.put_line ('PROC_ONE - DEFINER RIGHTS');
   show_users ();
   user_one.proc_one;
END;
/

GRANT execute on proc_two to user_one;
/

CONNECT user_one/user_one

CREATE OR REPLACE PROCEDURE proc_three
AUTHID CURRENT_USER
IS
   PROCEDURE show_users
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
         'Session user = ' || SYS_CONTEXT ('USERENV', 'SESSION_USER')
      );
      DBMS_OUTPUT.put_line (
         'Current user = ' || SYS_CONTEXT ('USERENV', 'CURRENT_USER')
      );
   END;
BEGIN
   DBMS_OUTPUT.put_line ('PROC_THREE - INVOKER RIGHTS');
   show_users ();
   user_two.proc_two;
END;
/

BEGIN
   proc_three;
END;
/

/* Clean up users */

CONNECT sys/quest as SYSDBA

DECLARE
   user_does_not_exist exception;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE drop_user (user_in in VARCHAR2)
   IS
   BEGIN
      EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;
BEGIN
   drop_user ('USER_ONE');
   drop_user ('USER_TWO');
END;
/