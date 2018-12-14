CREATE OR REPLACE FUNCTION stop10
   RETURN VARCHAR2
IS
BEGIN
   DBMS_LOCK.sleep (5);
   RETURN TO_CHAR (SYSDATE, 'hh:mi:ss');
END;
/

COLUMN stop10 format a10
SELECT TO_CHAR (SYSDATE, 'hh:mi:ss') timestamp, stop10
  FROM emp
 WHERE ROWNUM < 5;
 