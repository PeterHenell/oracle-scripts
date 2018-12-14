CONNECT system/manager
CREATE ROLE test_irm_r not identified;
GRANT test_irm_r to demo;
CONNECT demo/demo
CREATE TABLE test_irm_t (
   d date);
GRANT select on test_irm_t to test_irm_r;
INSERT INTO test_irm_t
     VALUES (SYSDATE);
COMMIT;
CONNECT scott/tiger
CREATE TABLE test_irm_t (
   d date);
CREATE OR REPLACE PROCEDURE test_irm_p
   AUTHID CURRENT_USER
IS
   num PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO num
     FROM test_irm_t;
   DBMS_OUTPUT.put_line ('Count of rows in test_irm_t: ' || num);
END;
/
GRANT execute on test_irm_p to demo;
CONNECT demo/demo
SET serveroutput on
EXEC scott.test_irm_p
