/* Formatted on 2002/04/01 00:00 (Formatter Plus v4.5.2) */
-- Autonomous Transaction Example - convert insert to update for sqlload
-- Chris Barr, 2/14/2002


DROP TABLE run_params;


CREATE TABLE run_params (
  NAME   VARCHAR2(20) PRIMARY KEY,
  VALUE  VARCHAR2(20));


INSERT INTO run_params
     VALUES ('TARGET', 'xyz');
INSERT INTO run_params
     VALUES ('CURRENT', 'abc');
COMMIT ;


-- -----------------------------------------------------------------  
CREATE OR REPLACE TRIGGER update_on_insert
   BEFORE INSERT
   ON run_params
   FOR EACH ROW
DECLARE
   saved_value   run_params.VALUE%TYPE; -- 2 cols: name, value
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT VALUE
     INTO saved_value
     FROM run_params
    WHERE NAME = 'TARGET';

   IF SQL%FOUND
   THEN
      -- Delete to enable insert of new
      DELETE FROM run_params
            WHERE NAME = 'TARGET';

      COMMIT;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      -- Restore original row
      INSERT INTO run_params
                  (NAME, VALUE)
           VALUES ('TARGET', saved_value);

      COMMIT;
      -- TBD: add logging, etc.
      RAISE;
END;
/
-- -----------------------------------------------------------------
-- Test & Proof:  insert, count before & after, ..


SELECT    'Before Insert, count: '
       || COUNT (*)
  FROM run_params;


INSERT INTO run_params
     VALUES ('TARGET', 'TEST');
COMMIT ;


SELECT    'After Insert, count:  '
       || COUNT (*)
  FROM run_params;
SELECT *
  FROM run_params;
DROP TABLE run_params;


CREATE OR REPLACE TRIGGER update_on_insert
   BEFORE INSERT
   ON run_params
   FOR EACH ROW
DECLARE
   saved_value   run_params.VALUE%TYPE; -- 2 cols: name, value
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT VALUE
     INTO saved_value
     FROM run_params
    WHERE NAME = 'TARGET';

   IF SQL%FOUND
   THEN
      -- Delete to enable insert of new
      DELETE FROM run_params
            WHERE NAME = 'TARGET';

      COMMIT;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      -- Restore original row
      INSERT INTO run_params
                  (NAME, VALUE)
           VALUES ('TARGET', saved_value);

      COMMIT;
      -- TBD: add logging, etc.
      RAISE;
END;
/

