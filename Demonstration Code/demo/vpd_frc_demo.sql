SPOOL demo.log

CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist EXCEPTION;
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
   create_user ('appowner');
   create_user ('user1');
   create_user ('user2');
END;
/

SPOOL vpd_frc_demo.log

CONNECT appowner/appowner

DROP table data_by_user
/

CREATE TABLE data_by_user
(
   id           NUMBER
 , text         VARCHAR2 (100)
 , created_by   VARCHAR2 (30)
)
/

CREATE OR REPLACE TRIGGER data_by_user_audit
   BEFORE INSERT
   ON data_by_user
   FOR EACH ROW
DECLARE
BEGIN
   :new.created_by := USER;
END data_by_user_audit;
/

GRANT ALL ON data_by_user TO user1
/
GRANT ALL ON data_by_user TO user2
/

CREATE OR REPLACE FUNCTION text_for_id (id_in IN data_by_user.id%TYPE)
   RETURN data_by_user.text%TYPE
   RESULT_CACHE RELIES_ON ( data_by_user )
IS
   l_text   data_by_user.text%TYPE;
BEGIN
   DBMS_OUTPUT.put_line ('Retrieving text for ID ' || id_in);

   SELECT dbu.text
     INTO l_text
     FROM data_by_user dbu
    WHERE dbu.id = text_for_id.id_in;

   RETURN l_text;
END text_for_id;
/

GRANT EXECUTE ON text_for_id TO user1
/
GRANT EXECUTE ON text_for_id TO user2
/

connect user1/user1

BEGIN
   INSERT INTO appowner.data_by_user (id, text
                                     )
       VALUES (1, 'User1 data row 1'
              );

   INSERT INTO appowner.data_by_user (id, text
                                     )
       VALUES (2, 'User1 data row 2'
              );

   COMMIT;
END;
/

connect user2/user2

BEGIN
   INSERT INTO appowner.data_by_user (id, text
                                     )
       VALUES (3, 'User2 data row 1'
              );

   INSERT INTO appowner.data_by_user (id, text
                                     )
       VALUES (4, 'User2 data row 2'
              );

   COMMIT;
END;
/

connect user1/user1

SET SERVEROUTPUT ON

SELECT *
  FROM appowner.data_by_user
 WHERE id = 3;
/

BEGIN
   DBMS_OUTPUT.put_line (appowner.text_for_id (3));
   DBMS_OUTPUT.put_line (appowner.text_for_id (3));
END;
/

connect user2/user2

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line (appowner.text_for_id (3));
END;
/

connect appowner/appowner

CREATE OR REPLACE PACKAGE vpd_policies
IS
   FUNCTION your_data_only (schema_in VARCHAR2, NAME_IN VARCHAR2)
      RETURN VARCHAR2;
END vpd_policies;
/

CREATE OR REPLACE PACKAGE BODY vpd_policies
IS
   FUNCTION your_data_only (schema_in VARCHAR2, NAME_IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'created_by = ''' || USER || '''';
   END your_data_only;
END vpd_policies;
/

BEGIN
   DBMS_RLS.add_policy (object_schema => 'APPOWNER'
                      , object_name => 'data_by_user'
                      , policy_name => 'Your_data_only'
                      , function_schema => 'APPOWNER'
                      , policy_function => 'vpd_policies.your_data_only'
                      , statement_types => 'SELECT'
                      , update_check => TRUE
                       );
END;
/

connect user1/user1

/* Now I cannot see the data in this table because
   of the access policy. */
   
SELECT *
  FROM appowner.data_by_user
 WHERE id = 3;
/

BEGIN
   /* Flush the cache by performing a nonsense update. */
   UPDATE appowner.data_by_user
      SET text = text;
   COMMIT;
END;
/

BEGIN   
   DBMS_OUTPUT.put_line (appowner.text_for_id (3));
END;
/

connect user2/user2

SELECT *
  FROM appowner.data_by_user
 WHERE id = 3;
/

BEGIN
   /* Flush the cache by performing a nonsense update. */
   UPDATE appowner.data_by_user
      SET text = text;
   COMMIT;
   
   DBMS_OUTPUT.put_line (appowner.text_for_id (3));
END;
/

/*
Add the user name to the parameter list of the result cache function.
*/

CONNECT appowner/appowner

CREATE OR REPLACE FUNCTION priv_text_for_id (user_in in varchar2, id_in IN data_by_user.id%TYPE)
   RETURN data_by_user.text%TYPE
   RESULT_CACHE RELIES_ON ( data_by_user )
IS
   l_text   data_by_user.text%TYPE;
BEGIN
   DBMS_OUTPUT.put_line ('Retrieving text for ID ' || id_in);

   SELECT dbu.text
     INTO l_text
     FROM data_by_user dbu
    WHERE dbu.id = priv_text_for_id.id_in;

   RETURN l_text;
END priv_text_for_id;
/

SHOW ERRORS

CREATE OR REPLACE FUNCTION text_for_id (id_in IN data_by_user.id%TYPE)
   RETURN data_by_user.text%TYPE
IS
   
BEGIN
   return priv_text_for_id (user, id_in);
END text_for_id;
/

SHOW ERRORS

connect user2/user2

/* Cache the data for id 3 */

BEGIN
   DBMS_OUTPUT.put_line (appowner.text_for_id (3));
END;
/

connect user1/user1

/* Try to get text for id 3. */

BEGIN   
   DBMS_OUTPUT.put_line (appowner.text_for_id (3));
END;
/

SPOOL OFF