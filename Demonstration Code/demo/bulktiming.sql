-- bulktiming.sql

DROP TABLE parts
/

DROP TABLE parts2
/

CREATE TABLE parts
(
   partnum    NUMBER
 , partname   VARCHAR2 (15)
)
/

CREATE TABLE parts2
(
   partnum    NUMBER
 , partname   VARCHAR2 (15)
)
/

DROP TYPE parts_ot FORCE
/

CREATE OR REPLACE TYPE parts_ot IS OBJECT
                  (partnum NUMBER, partname VARCHAR2 (15))
/

CREATE OR REPLACE TYPE partstab IS TABLE OF parts_ot;
/

CREATE OR REPLACE PROCEDURE compare_fetching (num IN INTEGER)
IS
   TYPE numtab IS TABLE OF parts.partnum%TYPE
                     INDEX BY BINARY_INTEGER;

   TYPE nametab IS TABLE OF parts.partname%TYPE
                      INDEX BY BINARY_INTEGER;

   pnums       numtab;
   pnames      nametab;

   TYPE parts_tabtype IS TABLE OF parts%ROWTYPE
                            INDEX BY BINARY_INTEGER;

   parts_tab   parts_tabtype;

   l_limit     PLS_INTEGER := 100;

   CURSOR parts_cur
   IS
      SELECT * FROM parts;

   l_part      parts_cur%ROWTYPE;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE parts';

   /* Load up the table. */
   FOR indx IN 1 .. num
   LOOP
      INSERT INTO parts
           VALUES (indx, 'Part ' || TO_CHAR (indx));
   END LOOP;

   COMMIT;

   DBMS_SESSION.free_unused_user_memory;

   /* Fetch the data row by row */
   sf_timer.start_timer;

   OPEN parts_cur;

   LOOP
      FETCH parts_cur INTO l_part;

      EXIT WHEN parts_cur%NOTFOUND;
   END LOOP;

   CLOSE parts_cur;

   sf_timer.show_elapsed_time ('Row-by-row fetch ' || num);

   /* Clean up the in-memory data structures. */
   pnums.delete;
   pnames.delete;
   DBMS_SESSION.free_unused_user_memory;

   /* Fetch the data in bulk */
   sf_timer.start_timer;

   SELECT *
     BULK COLLECT INTO parts_tab 
     FROM parts;

   p.l ('SQL%ROWCOUNT = ' || SQL%ROWCOUNT);

   sf_timer.show_elapsed_time ('BULK COLLECT ' || num);
END;
/

CREATE OR REPLACE PROCEDURE compare_inserting (num IN INTEGER)
IS
   TYPE numtab IS TABLE OF parts.partnum%TYPE;

   TYPE nametab IS TABLE OF parts.partname%TYPE;

   pnums      numtab := numtab ();
   pnames     nametab := nametab ();
   parts_nt   partstab := partstab ();
BEGIN
   pnums.EXTEND (num);
   pnames.EXTEND (num);
   parts_nt.EXTEND (num);

   FOR indx IN 1 .. num
   LOOP
      pnums (indx) := indx;
      pnames (indx) := 'Part ' || TO_CHAR (indx);
      parts_nt (indx) := parts_ot (NULL, NULL);
      parts_nt (indx).partnum := indx;
      parts_nt (indx).partname := pnames (indx);
   END LOOP;

   sf_timer.start_timer;

   FOR indx IN 1 .. num
   LOOP
      INSERT INTO parts
           VALUES (indx, 'Part ' || TO_CHAR (indx));
   END LOOP;

   sf_timer.show_elapsed_time ('FOR loop (row by row)' || num);

   ROLLBACK;

   sf_timer.start_timer;

   FORALL indx IN pnums.FIRST .. pnums.LAST
      INSERT INTO parts
           VALUES (pnums (indx), pnames (indx));

   DBMS_OUTPUT.put_line ('SQL%ROWCOUNT = ' || SQL%ROWCOUNT);

   sf_timer.show_elapsed_time ('FORALL (bulk)' || num);

   ROLLBACK;

   sf_timer.start_timer;

   INSERT INTO parts
      SELECT * FROM TABLE (parts_nt);

   DBMS_OUTPUT.put_line ('SQL%ROWCOUNT = ' || SQL%ROWCOUNT);
   sf_timer.show_elapsed_time ('INS SEL from nested table ' || num);

   ROLLBACK;

   sf_timer.start_timer;

   INSERT /*+ APPEND */
         INTO  parts
      SELECT * FROM TABLE (parts_nt);

   DBMS_OUTPUT.put_line ('SQL%ROWCOUNT = ' || SQL%ROWCOUNT);
   sf_timer.show_elapsed_time ('INS SEL WITH DIRECT PATH ' || num);
END;
/

CREATE OR REPLACE PROCEDURE compare_insel_bulk (num IN INTEGER)
IS
   TYPE numtab IS TABLE OF parts.partnum%TYPE
                     INDEX BY BINARY_INTEGER;

   TYPE nametab IS TABLE OF parts.partname%TYPE
                      INDEX BY BINARY_INTEGER;

   pnums       numtab;
   pnames      nametab;

   TYPE parts_tabtype IS TABLE OF parts%ROWTYPE
                            INDEX BY BINARY_INTEGER;

   parts_tab   parts_tabtype;

   l_limit     PLS_INTEGER := 100;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE parts';

   /* Load up the table. */
   FOR indx IN 1 .. num
   LOOP
      INSERT INTO parts
           VALUES (indx, 'Part ' || TO_CHAR (indx));
   END LOOP;

   COMMIT;

   DBMS_SESSION.free_unused_user_memory;

   sf_timer.start_timer;

   INSERT INTO parts2
      SELECT * FROM parts;

   sf_timer.show_elapsed_time ('Insert Select');

   EXECUTE IMMEDIATE 'TRUNCATE TABLE parts2';

   DBMS_SESSION.free_unused_user_memory;

   sf_timer.start_timer;

   SELECT *
     BULK COLLECT INTO parts_tab
     FROM parts;

   FORALL indx IN parts_tab.FIRST .. parts_tab.LAST
      INSERT INTO parts2
           VALUES parts_tab (indx);

   sf_timer.show_elapsed_time ('BULK COLLECT - FORALL');
END;
/

BEGIN
   --compare_insel_bulk (100000);
   --compare_inserting (100000);
   compare_fetching (100000);
END;
/

/* Some results...

Compare Fetching

"Row-by-row fetch 100000" completed in: 1.3

"BULK COLLECT 100000" completed in: .06

Procedure created.

.FOR loop 1000 Elapsed: .21 seconds.
.FORALL 1000 Elapsed: .01 seconds.

.FOR loop 10000 Elapsed: 5.68 seconds.
.FORALL 10000 Elapsed: .15 seconds.

PL/SQL procedure successfully completed.


Procedure created.

Input truncated to 4 characters
.Single row fetch 1000 Elapsed: .06 seconds.
.BULK COLLECT 1000 Elapsed: .01 seconds.

.Single row fetch 10000 Elapsed: .59 seconds.
.BULK COLLECT 10000 Elapsed: .16 seconds.

Insert Bulk Select 

10000 rows

Insert Select Elapsed: .05 seconds.
BULK COLLECT - FORALL Elapsed: .1 seconds.

100000 rows

Insert Select Elapsed: .38 seconds.
BULK COLLECT - FORALL Elapsed: 1.02 seconds.

*/