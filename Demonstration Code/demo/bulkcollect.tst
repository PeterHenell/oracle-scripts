DROP TABLE parts;

CREATE TABLE parts (partnum NUMBER, partname VARCHAR2 (15));

CREATE OR REPLACE PROCEDURE compare_fetching (num IN INTEGER)
IS
   TYPE numtab IS TABLE OF parts.partnum%TYPE
                     INDEX BY BINARY_INTEGER;

   TYPE nametab IS TABLE OF parts.partname%TYPE
                      INDEX BY BINARY_INTEGER;

   pnums    numtab;
   pnames   nametab;

   CURSOR cur
   IS
      SELECT *
        FROM parts;

   rec      cur%ROWTYPE;
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE parts';

   /* Load up the table. */
   FOR indx IN 1 .. num
   LOOP
      INSERT INTO parts
          VALUES (indx, 'Part ' || TO_CHAR (indx)
                 );
   END LOOP;

   COMMIT;

   DBMS_SESSION.free_unused_user_memory;

   /* Fetch the data row by row */
   sf_timer.start_timer;

   FOR rec IN (SELECT *
                 FROM parts)
   LOOP
      pnums (SQL%ROWCOUNT) := rec.partnum;
      pnames (SQL%ROWCOUNT) := rec.partname;
   END LOOP;

   sf_timer.show_elapsed_time ('CFL fetch ' || num);

   /* Fetch the data row by row */
   sf_timer.start_timer;

   OPEN cur;

   LOOP
      FETCH cur
      INTO rec;

      EXIT WHEN cur%NOTFOUND;
   END LOOP;

   CLOSE cur;

   sf_timer.show_elapsed_time ('Explicit row by row fetch ' || num);

   /* Clean up the in-memory data structures. */
   pnums.delete;
   pnames.delete;
   DBMS_SESSION.free_unused_user_memory;

   /* Fetch the data in bulk */
   sf_timer.start_timer;

   SELECT *
     BULK COLLECT
     INTO pnums, pnames
     FROM parts;

   sf_timer.show_elapsed_time ('BULK COLLECT ' || num);
END;
/

BEGIN
   compare_fetching (300000);
END;
/

/*
CFL fetch 300000 - Elapsed CPU : .19 seconds.
Explicit row by row fetch 300000 - Elapsed CPU : 3.55 seconds.
BULK COLLECT 300000 - Elapsed CPU : .09 seconds.

11g

CFL fetch 300000 - Elapsed CPU : .2 seconds. Factored: 0 seconds.
Explicit row by row fetch 300000 - Elapsed CPU : 4.06 seconds. Factored: .00004 seconds.
BULK COLLECT 300000 - Elapsed CPU : .14 seconds. Factored: 0 seconds.

*/