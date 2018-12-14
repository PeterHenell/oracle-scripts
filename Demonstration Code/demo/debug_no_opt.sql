CREATE OR REPLACE PROCEDURE plch_test
IS
   c   NUMBER := 0;
BEGIN
   FOR r IN (SELECT *
               FROM user_objects check_fetches
              WHERE ROWNUM <= 1000)
   LOOP
      c := c + 1;
   END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE show_fetch_count (sql_like_in IN VARCHAR2)
IS
   l_count   PLS_INTEGER;
BEGIN
   FOR rec IN (  SELECT *
                   FROM v$sql
                  WHERE sql_text LIKE '%' || sql_like_in || '%'
               ORDER BY fetches)
   LOOP
      sys.DBMS_OUTPUT.put_line (rec.sql_text || ': ' || rec.fetches);
   END LOOP;
END;
/

ALTER SESSION SET plsql_optimize_level = 2
/

ALTER PROCEDURE plch_test COMPILE;

BEGIN
   plch_test;
END;
/

ALTER PROCEDURE plch_test COMPILE DEBUG
/

BEGIN
   plch_test;
END;
/

BEGIN
   show_fetch_count ('SELECT%CHECK_FETCHES');
END;
/