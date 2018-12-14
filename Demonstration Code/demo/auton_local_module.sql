DROP TABLE inner_at_table
/
CREATE TABLE inner_at_table (val VARCHAR2(100))
/

CREATE OR REPLACE PROCEDURE outer_at
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

   PROCEDURE inner_at
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      INSERT INTO inner_at_table
           VALUES ('inner at');

      COMMIT;
   END inner_at;
BEGIN
   INSERT INTO inner_at_table
        VALUES ('outer at1');

   inner_at;
   ROLLBACK;

   INSERT INTO inner_at_table
        VALUES ('outer at2');

   COMMIT;
END outer_at;
/

BEGIN
   outer_at;
END;
/

SELECT *
  FROM inner_at_table
/