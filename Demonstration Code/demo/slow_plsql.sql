SET TIMING ON

CREATE TABLE is_plsql_slow (n NUMBER, d DATE, v VARCHAR2(100))
/

BEGIN
   FOR indx IN 1 .. 10000000
   LOOP
      INSERT INTO is_plsql_slow
           VALUES ( indx, SYSDATE, TO_CHAR ( indx ));
   END LOOP;

   COMMIT;
END;
/

SELECT COUNT ( * )
        FROM is_plsql_slow, is_plsql_slow
/
		
DECLARE
   CURSOR x
   IS
      SELECT COUNT ( * )
        FROM is_plsql_slow, is_plsql_slow;
BEGIN
   OPEN x;

   FETCH x
    INTO l;

   CLOSE x;

   DBMS_OUTPUT.put_line ( l );
END;
/
