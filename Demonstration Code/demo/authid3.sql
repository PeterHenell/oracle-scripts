/* Demonstration of back-and-forth between invoker rights and definer rights. */

CONNECT demo/demo
CREATE TABLE dummy_tab1 (dummy VARCHAR2(30));
INSERT INTO dummy_tab1 VALUES (USER);
CREATE PROCEDURE dummy0 IS
BEGIN
   DBMS_OUTPUT.put_line ('Dummy1 called from ' || USER);
END;
/
CONNECT scott/tiger
CREATE TABLE dummy_tab1 (dummy VARCHAR2(30));
INSERT INTO dummy_tab1 VALUES (USER);
CREATE PROCEDURE dummy0 IS
BEGIN
   DBMS_OUTPUT.put_line ('Dummy1 called from ' || USER);
END;
/
CREATE PROCEDURE dummy2 AUTHID CURRENT_USER 
IS
BEGIN
   dummy1;
END;
/
GRANT execute on dummy2 to public;
EXEC
CONNECT demo/demo
SET serveroutput on
EXEC scott.dummy2
