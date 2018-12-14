DROP TABLE errlog;

CREATE TABLE errlog (
   errnum INTEGER,
   errmsg VARCHAR2(200)
   );

CREATE OR REPLACE PROCEDURE test_lostlog (
   propagating IN BOOLEAN)

/* Use a savepoint to preserve the log insert. */

IS
   rec emp%ROWTYPE;
   v_err INTEGER;
BEGIN
   UPDATE emp SET sal = 1000;

   SELECT * INTO rec
     FROM emp
    WHERE empno = -100;
EXCEPTION
   WHEN OTHERS
   THEN
      v_err := SQLCODE;

      ROLLBACK TO last_log_entry;

      INSERT INTO errlog 
         VALUES (v_err, 'No employee for number -100');

      SAVEPOINT last_log_entry;

      IF propagating 
      THEN
         RAISE;
      END IF;
END;
/

BEGIN
   test_lostlog (FALSE);
END;
/

SELECT * FROM errlog;

CREATE OR REPLACE PROCEDURE test_lostlog (
   propagating IN BOOLEAN)

/* Set a savepoint at start of program to avoid error. */

IS
   rec emp%ROWTYPE;
   v_err INTEGER;
BEGIN
   SAVEPOINT last_log_entry;

   UPDATE emp SET sal = 1000;

   SELECT * INTO rec
     FROM emp
    WHERE empno = -100;
EXCEPTION
   WHEN OTHERS
   THEN
      v_err := SQLCODE;

      ROLLBACK TO last_log_entry;

      INSERT INTO errlog 
         VALUES (v_err, 'No employee for number -100');

      SAVEPOINT last_log_entry;

      IF propagating 
      THEN
         RAISE;
      END IF;
END;
/

BEGIN
   test_lostlog (FALSE);
END;
/

SELECT * FROM errlog;

