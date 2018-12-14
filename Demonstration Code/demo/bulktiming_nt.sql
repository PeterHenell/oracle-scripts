-- bulktiming.sql

DROP TABLE parts;

CREATE TABLE parts (partnum NUMBER, partname VARCHAR2 (15))
/

CREATE OR REPLACE TYPE parts_ot IS OBJECT
   (partnum NUMBER, partname VARCHAR2 (15))
/

CREATE OR REPLACE TYPE partstab IS TABLE OF parts_ot;
/

CREATE OR REPLACE PROCEDURE compare_inserting (num IN INTEGER)
IS
   TYPE numtab IS TABLE OF parts.partnum%TYPE;

   TYPE nametab IS TABLE OF parts.partname%TYPE;

   pnums      numtab;
   pnames     nametab;
   parts_nt   partstab := partstab();
BEGIN
   pnums.EXTEND (num);
   pnames.EXTEND (num);
   parts_nt.EXTEND (num);

   FOR indx IN 1 .. num
   LOOP
      pnums (indx) := indx;
      pnames (indx) := 'Part ' || TO_CHAR (indx);
      parts_nt (indx).partnum := indx;
      parts_nt (indx).partname := pnames (indx);
   END LOOP;

   sf_timer.start_timer;

   FOR indx IN 1 .. num
   LOOP
      INSERT INTO parts
          VALUES (pnums (indx), pnames (indx)
                 );
   END LOOP;

   sf_timer.show_elapsed_time ('FOR loop ' || num);

   ROLLBACK;

   sf_timer.start_timer;

   FORALL indx IN pnums.FIRST .. pnums.LAST
      INSERT INTO parts
          VALUES (pnums (indx), pnames (indx)
                 );

   p.l ('SQL%ROWCOUNT = ' || SQL%ROWCOUNT);
   sf_timer.show_elapsed_time ('FORALL ' || num);

   ROLLBACK;

   sf_timer.start_timer;

   INSERT INTO parts
      SELECT *
        FROM TABLE (parts_nt);

   p.l ('SQL%ROWCOUNT = ' || SQL%ROWCOUNT);
   sf_timer.show_elapsed_time ('INS SEL WITH NT ' || num);

   ROLLBACK;
END;
/

BEGIN
   compare_inserting (10000);
END;
/