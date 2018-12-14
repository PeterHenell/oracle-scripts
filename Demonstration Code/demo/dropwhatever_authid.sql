connect hr/hr

CREATE OR REPLACE PROCEDURE drop_whatever (nm IN VARCHAR2, typ IN VARCHAR2)
   AUTHID DEFINER
IS
BEGIN
   EXECUTE IMMEDIATE 'DROP ' || typ || ' ' || nm;

   DBMS_OUTPUT.put_line ('Dropped ' || typ || ' ' || nm || ' - SUCCESSFUL!');
END;
/

GRANT EXECUTE ON drop_whatever TO scott
/

DROP TABLE drop_this_one
/

CONNECT scott/tiger

SET SERVEROUTPUT ON

CREATE TABLE drop_this_one (n NUMBER)
/

BEGIN
   hr.drop_whatever ('drop_this_one', 'TABLE');
END;
/

DESC drop_this_one

connect hr/hr

CREATE OR REPLACE PROCEDURE drop_whatever (nm IN VARCHAR2, typ IN VARCHAR2)
   AUTHID CURRENT_USER
IS
BEGIN
   EXECUTE IMMEDIATE 'DROP ' || typ || ' ' || nm;

   DBMS_OUTPUT.put_line ('Dropped ' || typ || ' ' || nm || ' - SUCCESSFUL!');
END;
/

GRANT EXECUTE ON drop_whatever TO scott
/

CREATE TABLE drop_this_one (n NUMBER)
/

CONNECT scott/tiger

SET SERVEROUTPUT ON

BEGIN
   hr.drop_whatever ('drop_this_one', 'TABLE');
END;
/

DESC drop_this_one