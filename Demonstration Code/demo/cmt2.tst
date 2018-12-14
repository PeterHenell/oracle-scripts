/* Special privilege needed to execute these commands. */

CREATE ROLLBACK SEGMENT bigone;
ALTER ROLLBACK SEGMENT bigone ONLINE; 

/* Create temporary data for use in the script. */

DROP TABLE emp2;
CREATE TABLE emp2 AS SELECT * FROM emp;

SELECT COUNT(*) FROM emp2;

CREATE OR REPLACE PROCEDURE my_application (counter IN INTEGER)
IS
BEGIN
   /* Define the current rollback segment. */
   PLVcmt.set_rbseg ('bigone');

   FOR cmtind IN 1 .. counter
   LOOP
      DELETE FROM emp2 WHERE ROWNUM < 2;
      PLVcmt.perform_commit (
        'DELETED ' || SQL%ROWCOUNT || 
        ' on iteration ' || cmtind);   END LOOP;
END;
/

BEGIN
   my_application (5);
END;
/

SELECT COUNT(*) FROM emp2;

ROLLBACK;

SELECT COUNT(*) FROM emp2;


