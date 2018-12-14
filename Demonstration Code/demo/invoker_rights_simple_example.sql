CONNECT Sys/pw AS SYSDBA

DECLARE
   user_does_not_exist   EXCEPTION;
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

CREATE OR REPLACE FUNCTION table_count (
   table_name_in   IN   all_tables.table_name%TYPE
)
   RETURN PLS_INTEGER
   AUTHID DEFINER
IS
   l_return       PLS_INTEGER;
BEGIN
   EXECUTE IMMEDIATE 
      'SELECT COUNT(*) FROM ' || 
         DBMS_ASSERT.SQL_OBJECT_NAME (table_name_in)
   INTO l_return;

   RETURN l_return;
END table_count;
/

GRANT EXECUTE ON table_count To Usr2
/

CREATE TABLE MY_TABLE (
   n NUMBER)
/

Connect Usr2/pw

CREATE TABLE MY_TABLE (
   n NUMBER)
/
BEGIN
    INSERT INTO MY_TABLE VALUES (1);
    INSERT INTO MY_TABLE VALUES (2);
    INSERT INTO MY_TABLE VALUES (3);
    COMMIT;
END;
/

CREATE TABLE MY_TABLE2 (
   n NUMBER)
/


Connect Usr1/pw

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line (table_count ('MY_TABLE'));
END;
/

CONNECT Usr2/pw

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line (Usr1.table_count ('MY_TABLE'));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (Usr1.table_count ('MY_TABLE2'));
END;
/


Connect Usr1/pw

CREATE OR REPLACE FUNCTION table_count (
   table_name_in   IN   all_tables.table_name%TYPE
)
   RETURN PLS_INTEGER
   AUTHID CURRENT_USER
IS
   l_return       PLS_INTEGER;
BEGIN
   EXECUTE IMMEDIATE 
      'SELECT COUNT(*) FROM ' || 
         DBMS_ASSERT.SQL_OBJECT_NAME (table_name_in)
   INTO l_return;

   RETURN l_return;
END table_count;
/

Connect Usr1/pw

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line (table_count ('MY_TABLE'));
END;
/

CONNECT Usr2/pw

SET SERVEROUTPUT ON

BEGIN
   DBMS_OUTPUT.put_line (Usr1.table_count ('MY_TABLE'));
END;
/