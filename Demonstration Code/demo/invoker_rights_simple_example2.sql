CONNECT Sys/pw AS SYSDBA

DECLARE
   user_does_not_exist exception;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
BEGIN
   /* Drop users if they already exist. */
   BEGIN
      EXECUTE IMMEDIATE 'drop user Usr1 cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   BEGIN
      EXECUTE IMMEDIATE 'drop user Usr2 cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   /* Grant required privileges...*/
   EXECUTE IMMEDIATE '
    grant Create Session, Resource to Usr1 identified by pw';

   EXECUTE IMMEDIATE '
    grant Create Session, Resource to Usr2 identified by pw';
END;
/

Connect Usr1/pw

CREATE TABLE our_employees
(
   employee_id   integer
 , first_name    varchar2 (100)
 , last_name     varchar2 (100)
)
/

BEGIN
   INSERT INTO our_employees
       VALUES (100, 'Steven', 'Feuerstein'
              );

   INSERT INTO our_employees
       VALUES (200, 'Lakshmi', 'Silva'
              );

   INSERT INTO our_employees
       VALUES (300, 'Chris', 'Thompson'
              );
END;
/

CREATE OR REPLACE PROCEDURE show_employees
   AUTHID DEFINER
IS
   l_return   pls_integer;
BEGIN
   FOR rec IN (SELECT *
                 FROM our_employeees)
   LOOP
      DBMS_OUTPUT.put_line (
         rec.employee_id || ': ' || rec.last_name || ',' || rec.first_name
      );
   END LOOP;
END show_employees;
/

GRANT EXECUTE ON show_employees TO usr2
/

Connect Usr2/pw

CREATE TABLE our_employees
(
   employee_id   integer
 , first_name    varchar2 (100)
 , last_name     varchar2 (100)
)
/

Connect Usr1/pw

SET SERVEROUTPUT ON

BEGIN
   show_employees();
END;
/

CONNECT Usr2/pw

SET SERVEROUTPUT ON

BEGIN
   show_employees();
END;
/


Connect Usr1/pw

CREATE OR REPLACE PROCEDURE show_employees
   AUTHID CURRENT_USER
IS
   l_return   pls_integer;
BEGIN
   FOR rec IN (SELECT *
                 FROM our_employeees)
   LOOP
      DBMS_OUTPUT.put_line (
         rec.employee_id || ': ' || rec.last_name || ',' || rec.first_name
      );
   END LOOP;
END show_employees;
/

Connect Usr1/pw

SET SERVEROUTPUT ON

BEGIN
   show_employees();
END;
/

CONNECT Usr2/pw

SET SERVEROUTPUT ON

BEGIN
   Usr1.show_employees();
END;
/