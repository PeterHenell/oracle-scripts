CREATE TABLE error_log (errcode INTEGER, errtext VARCHAR2(4000), created_on DATE, created_by VARCHAR2(30)
)
/

CREATE OR REPLACE PROCEDURE log_error (code IN INTEGER, msg IN VARCHAR2)
IS
BEGIN
   INSERT INTO error_log
               (errcode, errtext, created_on, created_by
               )
        VALUES (code, msg, SYSDATE, USER
               );
END log_error;
/

CREATE OR REPLACE PROCEDURE make_changes
IS
   PROCEDURE perform_first_change
   IS
   BEGIN
      RAISE NO_DATA_FOUND;
   END;

   PROCEDURE perform_second_change
   IS
   BEGIN
      RAISE NO_DATA_FOUND;
   END;
BEGIN
   perform_first_change ();
   perform_second_change ();
EXCEPTION
   WHEN OTHERS
   THEN
      log_error (SQLCODE, DBMS_UTILITY.format_error_stack);
      RAISE;
END;
/

BEGIN
   make_changes;
END;
/

SELECT * FROM error_log
/

CREATE OR REPLACE PROCEDURE log_error (
   code IN INTEGER, msg IN VARCHAR2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO error_log 
      (errcode, errtext, created_on, created_by)
   VALUES 
      (code, msg, SYSDATE, USER);

   COMMIT;
EXCEPTION
   WHEN OTHERS THEN ROLLBACK;
END log_error;
/

BEGIN
   make_changes;
END;
/

SELECT * FROM error_log
/
