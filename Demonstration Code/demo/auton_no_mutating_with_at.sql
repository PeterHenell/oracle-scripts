CREATE TABLE test_table (name VARCHAR2 (100))
/

BEGIN
   INSERT INTO test_table
       VALUES ('GEORGE'
              );

   COMMIT;
END;
/

-- Cannot query from triggering table...

CREATE OR REPLACE TRIGGER isit_mutating_trigger
   AFTER INSERT OR UPDATE
   ON test_table
   FOR EACH ROW
DECLARE
   myval   NUMBER;
BEGIN
   SELECT COUNT ( * )
     INTO myval
     FROM test_table;
END;
/

UPDATE test_table
   SET name = 'SAM';

ROLLBACK;

-- Now with autonomous transaction?

CREATE OR REPLACE TRIGGER isit_mutating_trigger
   AFTER INSERT OR UPDATE
   ON test_table
   FOR EACH ROW
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
   myval   NUMBER;
BEGIN
   SELECT COUNT ( * )
     INTO myval
     FROM test_table;
END;
/

UPDATE test_table
   SET name = 'SAM';

ROLLBACK;

DROP TRIGGER isit_mutating_trigger;