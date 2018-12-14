connect scott/tiger
@ssoo

exec drop_whatever ('XX%', '%');

CREATE OR REPLACE PROCEDURE xx_test
IS
BEGIN
   FOR rec IN  (SELECT *
                  FROM emp)
   LOOP
      DBMS_OUTPUT.put_line (rec.ename);
   END LOOP;
END;
/
GRANT execute on xx_test to demo;



CONNECT demo/demo


SELECT COUNT (*)
  FROM all_source
 WHERE owner = 'SCOTT' AND NAME LIKE 'XX%';


CONNECT scott/tiger


CREATE OR REPLACE PACKAGE xx_test_pkg
IS
   PROCEDURE dummy;
END;
/
CREATE OR REPLACE PACKAGE BODY xx_test_pkg
IS
   PROCEDURE dummy
   IS
   BEGIN
      FOR rec IN  (SELECT *
                     FROM emp)
      LOOP
         DBMS_OUTPUT.put_line (rec.ename);
      END LOOP;
   END;
END;
/
GRANT execute on xx_test_pkg to demo;


CONNECT demo/demo


SELECT COUNT (*)
  FROM all_source
 WHERE owner = 'SCOTT' AND NAME LIKE 'XX%';


CONNECT scott/tiger


CREATE OR REPLACE FUNCTION xx_code_count
   RETURN INTEGER
IS
   l_count   INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM all_source
    WHERE owner = 'SCOTT' AND NAME LIKE 'XX%';

   RETURN l_count;
END;
/
GRANT  execute on xx_code_count to demo;


CONNECT demo/demo


@ssoo

SELECT COUNT (*)
  FROM all_source
 WHERE owner = 'SCOTT' AND NAME LIKE 'XX%';
 
EXEC p.l('Count of rows of SCOTT source readable through procedure: ' || scott.xx_code_count);
