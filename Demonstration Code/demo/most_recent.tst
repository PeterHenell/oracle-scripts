DROP TABLE my_log
/
CREATE TABLE my_log (
   callstack VARCHAR2(4000))
/

CREATE OR REPLACE PROCEDURE log_error (stack_in IN VARCHAR2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO my_log
               (callstack
               )
        VALUES (stack_in
               );

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
      RAISE;
END log_error;
/

CREATE OR REPLACE PROCEDURE proc1
IS
BEGIN
   RAISE NO_DATA_FOUND;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      log_error
            (callstack.most_recent_program (DBMS_UTILITY.format_call_stack)
            );
      RAISE;
END proc1;
/

CREATE OR REPLACE PROCEDURE proc2
IS
BEGIN
   proc1;
END proc2;
/

CREATE OR REPLACE PROCEDURE proc3
IS
BEGIN
   proc2;
END proc3;
/

BEGIN
   proc3;
END;
/

SELECT *
  FROM my_log;

TRUNCATE TABLE my_log;

CREATE OR REPLACE PACKAGE pkg
IS
   PROCEDURE proc1;
END pkg;
/

CREATE OR REPLACE PACKAGE BODY pkg
IS
   PROCEDURE proc1
   IS
   BEGIN
      RAISE NO_DATA_FOUND;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         log_error
            (callstack.most_recent_program (DBMS_UTILITY.format_call_stack)
            );
         RAISE;
   END proc1;
END pkg;
/

CREATE OR REPLACE PROCEDURE proc2
IS
BEGIN
   pkg.proc1;
END proc2;
/

BEGIN
   proc3;
END;
/

SELECT *
  FROM my_log;

BEGIN
   -- Test package utility for very short stack.
   DBMS_OUTPUT.put_line
            (callstack.most_recent_program (DBMS_UTILITY.format_call_stack)
            );
END;
/