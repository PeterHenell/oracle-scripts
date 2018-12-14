/*
Demonstrate the effect of AUTHID CURRENT_USER
and also the fact that as soon as you come across
a definer rights program in the call stack, any
subsequent invoker rights programs resolve
CURRENT_USER back to the owner of the definer rights
program.
*/

CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist exception;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE create_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'DROP USER ' || user_in || ' CASCADE';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      /* Grant required privileges...*/
      EXECUTE IMMEDIATE   'GRANT CREATE SESSION, RESOURCE TO '
                       || user_in
                       || ' IDENTIFIED BY '
                       || user_in;
   END create_user;
BEGIN
   create_user ('utility_schema');
   create_user ('app_schema');
END;
/

SPOOL invdefinv.log

CONNECT utility_schema/utility_schema

CREATE TABLE parts (part_id  INTEGER, part_name VARCHAR2 (100))
/

CREATE OR REPLACE FUNCTION name_from_id (part_id_in IN parts.part_id%TYPE)
   RETURN parts.part_name%TYPE
   AUTHID CURRENT_USER
IS
   l_return   parts.part_name%TYPE;
BEGIN
   /* How did I get here? */
   DBMS_OUTPUT.put_line (DBMS_UTILITY.format_call_stack);

   SELECT parts.part_name
     INTO l_return
     FROM parts
    WHERE parts.part_id = part_id_in;

   RETURN l_return;
END name_from_id;
/

GRANT EXECUTE ON name_from_id TO app_schema
/

CREATE OR REPLACE PROCEDURE show_part_name (part_id_in IN parts.part_id%TYPE)
IS
   l_name   parts.part_name%TYPE;
BEGIN
   l_name := name_from_id (part_id_in);

   DBMS_OUTPUT.put_line ('Name for ID ' || part_id_in || ' = ' || l_name);
END show_part_name;
/

GRANT EXECUTE ON show_part_name TO app_schema
/

CONNECT app_schema/app_schema

CREATE TABLE parts (part_id  INTEGER, part_name VARCHAR2 (100))
/

BEGIN
   INSERT INTO parts
       VALUES (1, 'Widget'
              );

   INSERT INTO parts
       VALUES (2, 'Gizmo'
              );

   INSERT INTO parts
       VALUES (3, 'Washer'
              );

   COMMIT;
END;
/

SET SERVEROUTPUT ON FORMAT WRAPPED

BEGIN
   DBMS_OUTPUT.put_line (utility_schema.name_from_id (2));
END;
/

BEGIN
   utility_schema.show_part_name (2);
END;
/

/* Now demonstrate how you can protect your program by
   checking to see that we are still running in invoker
   rights */
   
CONNECT utility_schema/utility_schema   

CREATE OR REPLACE FUNCTION invoker_rights_lost
   RETURN BOOLEAN AUTHID CURRENT_USER
IS
   l_retval   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO l_retval
     FROM DUAL
    WHERE SYS_CONTEXT ('USERENV', 'SESSION_USER') =
          SYS_CONTEXT ('USERENV', 'CURRENT_USER');

   RETURN (l_retval = 0);
END invoker_rights_lost;
/

CREATE OR REPLACE FUNCTION name_from_id (
      part_id_in IN parts.part_id%TYPE)
   RETURN parts.part_name%TYPE
   AUTHID CURRENT_USER
IS
   l_return   parts.part_name%TYPE;
BEGIN
   IF invoker_rights_lost ()
   THEN
      RAISE_APPLICATION_ERROR (-20000,
         'Name_from_id not running under invoker rights.');
   ELSE

      SELECT parts.part_name
        INTO l_return
        FROM parts
       WHERE parts.part_id = part_id_in;

      RETURN l_return;
   END IF;
END name_from_id;
/
   
CONNECT app_schema/app_schema

SET SERVEROUTPUT ON FORMAT WRAPPED

BEGIN
   DBMS_OUTPUT.put_line (utility_schema.name_from_id (2));
END;
/

BEGIN
   utility_schema.show_part_name (2);
END;
/
SPOOL OFF

/* Don't forget to drop the user! */

CONNECT Sys/quest AS SYSDBA

DROP USER utility_schema CASCADE
/
DROP USER app_schema CASCADE
/