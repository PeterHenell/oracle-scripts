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

connect user_two/user_two

CREATE TABLE my_table (n NUMBER)
/

GRANT SELECT ON my_table TO user_one
/

connect user_one/user_one

CREATE TABLE my_table (n NUMBER)
/

BEGIN
   INSERT INTO my_table
       VALUES (1
              );

   COMMIT;
END;
/

DECLARE
   /*
   Demonstrate that changing the current schema does not affect
   the session and current users, but it does affect how names
   are resolved.
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

   PROCEDURE show_count
   IS
      l_count   PLS_INTEGER;
   BEGIN
      EXECUTE IMMEDIATE 'SELECT COUNT ( * ) FROM my_table' INTO l_count;

      DBMS_OUTPUT.put_line ('Table count = ' || l_count);
   END;
BEGIN
   show_users;
   show_count;

   EXECUTE IMMEDIATE 'alter session set current_schema = USER_TWO';

   show_users;
   show_count;
END;
/