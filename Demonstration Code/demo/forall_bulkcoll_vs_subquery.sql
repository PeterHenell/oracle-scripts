-- bulktiming.sql

DROP TABLE parts
/
DROP TABLE parts2
/
CREATE TABLE parts (
   partnum NUMBER,
   partname VARCHAR2(15)
   );

CREATE TABLE parts2 (
   partnum NUMBER,
   partname VARCHAR2(15)
   );

CREATE OR REPLACE TYPE numtab IS TABLE OF NUMBER
/

CREATE OR REPLACE TYPE nametab IS TABLE OF VARCHAR2 (15)
/

DECLARE
   pnums    numtab;
   pnames   nametab;
BEGIN
   FOR indx IN 1 .. 10000
   LOOP
      INSERT INTO parts
           VALUES (indx, 'Part ' || TO_CHAR (indx));
   END LOOP;

   INSERT INTO parts2
      SELECT *
        FROM parts;

   COMMIT;
   sf_timer.start_timer;

   SELECT partnum, partname
   BULK COLLECT INTO pnums, pnames
     FROM parts;

   FORALL indx IN pnums.FIRST .. pnums.LAST
      UPDATE parts2
         SET partname = 'A'
       WHERE partnum = pnums (indx);
   sf_timer.show_elapsed_time ('FORALL and BULK COLLECT');
   --
   sf_timer.start_timer;

   UPDATE parts2
      SET partname = 'A'
    WHERE partnum IN (SELECT *
                        FROM TABLE (pnums));

   sf_timer.show_elapsed_time ('UPDATE with TABLE sub-query');
END;
/