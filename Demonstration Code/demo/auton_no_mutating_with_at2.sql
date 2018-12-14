DROP TABLE test_table
/

CREATE TABLE test_table (name VARCHAR2 (100))
/

BEGIN
   INSERT INTO test_table
       VALUES ('GEORGE'
              );

   COMMIT;
END;
/

CREATE OR REPLACE FUNCTION count_in_test_table
   RETURN PLS_INTEGER
IS
   l_count   NUMBER;
BEGIN
   SELECT COUNT ( * )
     INTO l_count
     FROM test_table;

   RETURN l_count;
END count_in_test_table;
/

CREATE OR REPLACE TRIGGER after_update_on_test_table
   AFTER UPDATE
   ON test_table
   FOR EACH ROW
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   DBMS_OUTPUT.put_line ('Count from trigger: ' || count_in_test_table ());
END after_update_on_test_table;
/

SET SERVEROUTPUT ON FORMAT WRAPPED

BEGIN
   INSERT INTO test_table
       VALUES ('STEVEN'
              );

   DBMS_OUTPUT.put_line ('Count before update: ' || count_in_test_table ());

   UPDATE test_table
      SET name = 'SAM'
    WHERE name = 'GEORGE';
END;
/

ROLLBACK
/