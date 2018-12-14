DROP TABLE errlog;

CREATE TABLE errlog (
   errnum INTEGER,
	errmsg VARCHAR2(200)
	);

CREATE OR REPLACE PROCEDURE test_lostlog (
   propagating IN BOOLEAN)
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
	   INSERT INTO errlog 
	      VALUES (v_err, 'No employee for number -100');

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
SELECT DISTINCT sal FROM emp;

ROLLBACK;

BEGIN
   test_lostlog (TRUE);
END;
/

SELECT * FROM errlog;
SELECT DISTINCT sal FROM emp;

DROP TABLE errlog;
