/* Basic demonstration of AUTHID CURRENT_USER feature */

CONNECT demo/demo
CREATE PROCEDURE dummy1 IS
BEGIN
   DBMS_OUTPUT.put_line ('Dummy1 called from demo');
END;
/
GRANT execute on dummy1 to public;
CONNECT scott/tiger
CREATE PROCEDURE dummy1 IS
BEGIN
   DBMS_OUTPUT.put_line ('Dummy1 called from scott');
END;
/
GRANT execute on dummy1 to public;
CREATE PROCEDURE dummy2 AUTHID CURRENT_USER 
IS
BEGIN
   dummy1;
END;
/
GRANT execute on dummy2 to public;
EXEC scott.dummy2
CONNECT demo/demo
SET serveroutput on
EXEC scott.dummy2
