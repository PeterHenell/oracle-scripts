SPOOL authid_and_ots.log

CONNECT Sys/quest AS SYSDBA

DECLARE
   PROCEDURE create_user (NAME_IN IN VARCHAR2)
   IS
      user_does_not_exist EXCEPTION;
      PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
   BEGIN
      /* Drop user if already exists */
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || NAME_IN || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      /* Grant required privileges...*/
      BEGIN
         EXECUTE IMMEDIATE   'grant Create Session, Resource to '
                          || NAME_IN
                          || ' identified by '
                          || NAME_IN;

         EXECUTE IMMEDIATE 'grant Create Table to ' || NAME_IN;

         EXECUTE IMMEDIATE 'grant Create Procedure to ' || NAME_IN;

         EXECUTE IMMEDIATE 'grant Create Type to ' || NAME_IN;

         EXECUTE IMMEDIATE 'grant Create Synonym to ' || NAME_IN;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   END;
BEGIN
   create_user ('definer_schema');
   create_user ('invoker_schema');
END;
/

CONNECT definer_schema/definer_schema

CREATE OR REPLACE PROCEDURE show_dd_info (owner_in    IN VARCHAR2
                                        , typename_in IN VARCHAR2
                                         )
   AUTHID CURRENT_USER
IS
   l_count   PLS_INTEGER;
BEGIN
   SELECT COUNT ( * )
     INTO l_count
     FROM all_type_attrs
    WHERE owner = owner_in AND type_name = typename_in;

   DBMS_OUTPUT.put_line(   'Attribute count for '
                        || owner_in
                        || '-'
                        || typename_in
                        || ' = '
                        || l_count);

   SELECT COUNT ( * )
     INTO l_count
     FROM all_objects
    WHERE owner = owner_in AND object_name = typename_in;

   DBMS_OUTPUT.put_line(   'Object count for '
                        || owner_in
                        || '-'
                        || typename_in
                        || ' = '
                        || l_count);
END show_dd_info;
/

GRANT EXECUTE ON show_dd_info TO invoker_schema
/

connect invoker_schema/invoker_schema

set serveroutput on format wrapped

CREATE OR REPLACE TYPE my_ot1 IS OBJECT
   (v VARCHAR2 (100), d DATE, n NUMBER)
/

CREATE OR REPLACE TYPE my_ot2 IS OBJECT
   (v VARCHAR2 (100), d DATE, n NUMBER, t my_ot1)
/

BEGIN
   definer_schema.show_dd_info (USER, 'MY_OT2');
END;
/

CONNECT Sys/quest AS SYSDBA

DECLARE
   PROCEDURE drop_user (n VARCHAR2)
   IS
   BEGIN
      EXECUTE IMMEDIATE 'DROP USER ' || n || ' CASCADE';
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -1918
         THEN
            NULL;
         ELSE
            RAISE;
         END IF;
   END;
BEGIN
   drop_user ('invoker_schema');
   drop_user ('definer_schema');
END;
/

spool off