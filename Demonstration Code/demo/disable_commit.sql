CREATE OR REPLACE PROCEDURE autonomous_proc
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   NULL;
   COMMIT;
END autonomous_proc;
/

BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION DISABLE COMMIT IN PROCEDURE';

   autonomous_proc;
END;
/

/*
This alter session option does not seem to take effect
if executed outside the anonymous block.
*/

DROP TABLE otn_commit
/
CREATE TABLE otn_commit (n NUMBER)
/

CREATE OR REPLACE PROCEDURE add_to_otn_commit ( n_in IN NUMBER )
AUTHID CURRENT_USER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO otn_commit
        VALUES ( n_in );

   COMMIT;
END;
/

DECLARE
   l_count PLS_INTEGER;
BEGIN
   add_to_otn_commit ( 1 );
   ROLLBACK;

   SELECT COUNT ( * )
     INTO l_count
     FROM otn_commit;

   DBMS_OUTPUT.put_line ( 'count after rollback: ' || l_count );
END;
/

ALTER SESSION DISABLE COMMIT IN PROCEDURE
/

DECLARE
   l_count PLS_INTEGER;
BEGIN
   add_to_otn_commit ( 1 );
   ROLLBACK;

   SELECT COUNT ( * )
     INTO l_count
     FROM otn_commit;

   DBMS_OUTPUT.put_line ( 'count after rollback: ' || l_count );
END;
/

CREATE OR REPLACE PROCEDURE add_to_otn_commit ( n_in IN NUMBER )
AUTHID CURRENT_USER
IS
BEGIN
   INSERT INTO otn_commit
        VALUES ( n_in );
END;
/

DECLARE
   l_count PLS_INTEGER;
BEGIN
   add_to_otn_commit ( 1 );
   ROLLBACK;

   SELECT COUNT ( * )
     INTO l_count
     FROM otn_commit;

   DBMS_OUTPUT.put_line ( 'count after rollback: ' || l_count );
END;
/
