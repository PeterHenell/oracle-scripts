I create and populate this table in my schema:

CREATE TABLE plch_parts
(
   partnum    INTEGER PRIMARY KEY
 ,  partname   VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO plch_parts
        VALUES (100, 'Bezel');

   INSERT INTO plch_parts
        VALUES (200, 'Plate');
END;
/

CREATE OR REPLACE PROCEDURE plch_get_parts1
IS
BEGIN
   EXECUTE IMMEDIATE 'delete from plch_parts where partnum = 100';

   ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE plch_get_parts2
IS
BEGIN
   EXECUTE IMMEDIATE 'DELETE FROM PLCH_PARTS WHERE PARTNUM = :NUM'
      USING 100;

   ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE plch_get_parts3 (partnum_in IN INTEGER)
IS
BEGIN
   EXECUTE IMMEDIATE 'delete from plch_parts where partnum = :num'
      USING partnum_in;

   ROLLBACK;
END;
/

BEGIN
   plch_get_parts1;
   plch_get_parts2;
   plch_get_parts3 (100);
END;
/

BEGIN
   FOR rec IN (SELECT sql_text
                 FROM v$sqlarea a
                WHERE UPPER (sql_text) LIKE 'DELETE%PLCH_PARTS%')
   LOOP
      DBMS_OUTPUT.put_line (rec.sql_text);
   END LOOP;
END;
/

/* Clean up */

DROP TABLE plch_parts
/

DROP PROCEDURE plch_get_parts1
/

DROP PROCEDURE plch_get_parts2
/

DROP PROCEDURE plch_get_parts3
/