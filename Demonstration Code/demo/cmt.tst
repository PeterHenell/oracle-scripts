/* Create temporary data for use in the script. */

DROP TABLE emp2;
CREATE TABLE emp2 AS SELECT * FROM emp;

SELECT COUNT (*)
  FROM emp2;

CREATE OR REPLACE PROCEDURE my_application (
   counter   IN   INTEGER
)
IS
BEGIN
   FOR cmtind IN 1 .. counter
   LOOP
      DELETE FROM emp2
            WHERE ROWNUM < 2;

      --COMMIT;

      PLVcmt.perform_commit (
            'DELETED '
         || SQL%ROWCOUNT
         || ' on iteration '
         || cmtind
      );
   END LOOP;
END;
/

BEGIN
   my_application (5);
END;
/

SELECT COUNT (*)
  FROM emp2;

ROLLBACK ;

SELECT COUNT (*)
  FROM emp2;

