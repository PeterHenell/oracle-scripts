CREATE OR REPLACE PROCEDURE autonfail
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   x   INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO x
     FROM emp;

   pl (x);
   COMMIT;
END;
/

DECLARE
   x   INTEGER;
BEGIN
   DELETE FROM emp;

   SELECT COUNT (*)
     INTO x
     FROM emp;

   pl (x);
   autonfail;
   ROLLBACK;
END;
/