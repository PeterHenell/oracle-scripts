CREATE TABLE plch_count (n NUMBER)
/

BEGIN
   INSERT INTO plch_count
        VALUES (0);

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE plch_show_count
IS
   l_count   PLS_INTEGER;
BEGIN
   SELECT n INTO l_count FROM plch_count;

   DBMS_OUTPUT.put_line (l_count);
END;
/

DECLARE
   PROCEDURE increment_count
   AS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE plch_count
         SET n = n + 1;

      COMMIT;
   END increment_count;
BEGIN
   increment_count ();

   ROLLBACK;

   plch_show_count ();
END;
/

/* PLS-00710: Pragma AUTONOMOUS_TRANSACTION cannot be specified here */

BEGIN
   DECLARE
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE plch_count
         SET n = n + 1;

      COMMIT;
   END;

   plch_show_count ();
END;
/

BEGIN
   DECLARE
      PROCEDURE increment_count
      AS
         PRAGMA AUTONOMOUS_TRANSACTION;
      BEGIN
         UPDATE plch_count
            SET n = n + 1;

         COMMIT;
      END increment_count;
   BEGIN
      increment_count ();
   END;

   ROLLBACK;

   plch_show_count ();
END;
/

CREATE OR REPLACE PROCEDURE plch_increment_count
AS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   UPDATE plch_count
      SET n = n + 1;

   COMMIT;
END plch_increment_count;
/

BEGIN
   plch_increment_count ();


   ROLLBACK;

   plch_show_count ();
END;
/