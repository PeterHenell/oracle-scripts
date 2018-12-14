DROP TABLE xtemp
/

CREATE TABLE xtemp (n NUMBER)
/

CREATE OR REPLACE PROCEDURE add_xtemp
IS
   l   INTEGER;
BEGIN
   INSERT INTO xtemp
        VALUES (2);

   RAISE PROGRAM_ERROR;
EXCEPTION
   WHEN OTHERS
   THEN
      SELECT COUNT (*) INTO l FROM xtemp;

      DBMS_OUTPUT.put_line (l);

      RAISE;
END;
/

INSERT INTO xtemp
     VALUES (1)
/

BEGIN
   add_xtemp;
END;
/

SELECT COUNT (*) FROM xtemp
/