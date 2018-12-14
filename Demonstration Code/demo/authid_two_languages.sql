CONNECT Sys/pw AS SYSDBA

DECLARE
   user_does_not_exist exception;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);
BEGIN
   /* Drop users if they already exist. */
   BEGIN
      EXECUTE IMMEDIATE 'drop user CODE_SCHEMA cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   BEGIN
      EXECUTE IMMEDIATE 'drop user English cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   BEGIN
      EXECUTE IMMEDIATE 'drop user Spanish cascade';
   EXCEPTION
      WHEN user_does_not_exist
      THEN
         NULL;
   END;

   /* Grant required privileges...*/
   EXECUTE IMMEDIATE '
    grant Create Session, Resource to CODE_SCHEMA identified by code';

   EXECUTE IMMEDIATE '
    grant Create Session, Resource to English identified by hello';

   EXECUTE IMMEDIATE '
    grant Create Session, Resource to Spanish identified by hola';
END;
/

connect code_schema/code

CREATE TABLE messages (id  INTEGER, text VARCHAR2 (100))
/

CREATE OR REPLACE PROCEDURE show_message (id_in IN messages.id%TYPE)
   AUTHID CURRENT_USER
IS
   l_text   messages.text%TYPE;
BEGIN
   SELECT messages.text
     INTO l_text
     FROM messages
    WHERE messages.id = show_message.id_in;

   DBMS_OUTPUT.put_line (l_text);
END show_message;
/

GRANT EXECUTE ON show_message TO public
/

connect English/hello

CREATE TABLE messages (id  INTEGER, text VARCHAR2 (100))
/

BEGIN
   INSERT INTO messages
       VALUES (100, 'The house is green.'
              );

   INSERT INTO messages
       VALUES (200, 'You want to buy our products.'
              );

   COMMIT;
END;
/

connect Spanish/hola

CREATE TABLE messages (id  INTEGER, text VARCHAR2 (100))
/

BEGIN
   INSERT INTO messages
       VALUES (100, 'La casa es verde.'
              );

   INSERT INTO messages
       VALUES (200, 'Usted quiere comprar nuestros productos.'
              );

   COMMIT;
END;
/

connect English/hello

SET SERVEROUTPUT ON

BEGIN
   code_schema.show_message (100);
END;
/

connect Spanish/hola

SET SERVEROUTPUT ON

BEGIN
   code_schema.show_message (100);
END;
/

connect code_schema/code

CREATE OR REPLACE PROCEDURE show_message (id_in IN messages.id%TYPE)
   AUTHID DEFINER
IS
   l_text   messages.text%TYPE;
BEGIN
   SELECT messages.text
     INTO l_text
     FROM messages
    WHERE messages.id = show_message.id_in;

   DBMS_OUTPUT.put_line (l_text);
END show_message;
/

connect Spanish/hola

SET SERVEROUTPUT ON

BEGIN
   code_schema.show_message (100);
END;
/