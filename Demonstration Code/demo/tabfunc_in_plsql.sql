DROP  TYPE tickertype FORCE;
DROP  TYPE tickertypeset FORCE;
DROP  TABLE stocktable;
DROP  TABLE tickertable;

CREATE TABLE  stocktable (
  ticker VARCHAR2(20),
  trade_date DATE,
  open_price NUMBER,
  close_price NUMBER
);

BEGIN
   -- Populate the table.
   INSERT INTO stocktable
        VALUES ('ORCL'
              , SYSDATE
              , 11.5
              , 11
               );

   INSERT INTO stocktable
        VALUES ('QSFT'
              , SYSDATE
              , 13.2
              , 13.8
               );

   INSERT INTO stocktable
        VALUES ('MSFT'
              , SYSDATE
              , 27
              , 27.04
               );

   FOR indx IN 1 .. 10000
   LOOP
      -- Might as well be optimistic!
      INSERT INTO stocktable
           VALUES ('STK' || indx
                 , SYSDATE
                 , indx
                 , indx + 15
                  );
   END LOOP;

   COMMIT;
END;
/

/* 
   Note: Must use a nested table or varray of objects
   for the return type of a pipelined function
*/

CREATE TYPE tickertype AS OBJECT (
   ticker      VARCHAR2 (20)
 , pricedate   DATE
 , pricetype   VARCHAR2 (1)
 , price       NUMBER
);
/

CREATE TYPE tickertypeset AS TABLE OF tickertype;
/

CREATE TABLE tickertable
(
  ticker VARCHAR2(20),
  pricedate DATE,
  pricetype VARCHAR2(1),
  price NUMBER
)
/

CREATE OR REPLACE PACKAGE refcur_pkg
IS
   TYPE refcur_t IS REF CURSOR
      RETURN stocktable%ROWTYPE;

   TYPE tickertypeset IS TABLE OF tickertype;
END refcur_pkg;
/

CREATE OR REPLACE FUNCTION stockpivot_nopl (dataset refcur_pkg.refcur_t)
   RETURN tickertypeset
IS
   out_obj     tickertype    := tickertype (NULL, NULL, NULL, NULL);

   --
   TYPE dataset_tt IS TABLE OF stocktable%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_dataset   dataset_tt;
   retval      tickertypeset := tickertypeset ();
   l_row       PLS_INTEGER;
BEGIN
   FETCH dataset
   BULK COLLECT INTO l_dataset;

   CLOSE dataset;

   l_row := l_dataset.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      out_obj.ticker := l_dataset (l_row).ticker;
      out_obj.pricetype := 'O';
      out_obj.price := l_dataset (l_row).open_price;
      out_obj.pricedate := l_dataset (l_row).trade_date;
      retval.EXTEND;
      retval (retval.LAST) := out_obj;
      --
      out_obj.pricetype := 'C';
      out_obj.price := l_dataset (l_row).close_price;
      out_obj.pricedate := l_dataset (l_row).trade_date;
      retval.EXTEND;
      retval (retval.LAST) := out_obj;
      --
      l_row := l_dataset.NEXT (l_row);
   END LOOP;

   RETURN retval;
END;
/

SHO ERR

/* Pivot data with pipelining */

CREATE OR REPLACE FUNCTION stockpivot_pl (dataset refcur_pkg.refcur_t)
   RETURN tickertypeset PIPELINED
IS
   l_row_as_object   tickertype  := tickertype (NULL, NULL, NULL, NULL);

   TYPE dataset_tt IS TABLE OF dataset%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_dataset         dataset_tt;
   l_row             PLS_INTEGER;
BEGIN
   FETCH dataset
   BULK COLLECT INTO l_dataset;

   CLOSE dataset;

   l_row := l_dataset.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      -- first row
      l_row_as_object.ticker := l_dataset (l_row).ticker;
      l_row_as_object.pricetype := 'O';
      l_row_as_object.price := l_dataset (l_row).open_price;
      l_row_as_object.pricedate := l_dataset (l_row).trade_date;
      --
      PIPE ROW (l_row_as_object);
      -- second row
      l_row_as_object.pricetype := 'C';
      l_row_as_object.price := l_dataset (l_row).close_price;
      l_row_as_object.pricedate := l_dataset (l_row).trade_date;
      --
      PIPE ROW (l_row_as_object);
      l_row := l_dataset.NEXT (l_row);
   END LOOP;

   RETURN;
END;
/

SHO ERR


CREATE OR REPLACE PROCEDURE pipeline_performance
IS
   PROCEDURE init
   IS
   BEGIN
      DELETE FROM tickertable;

      COMMIT;
      DBMS_SESSION.free_unused_user_memory;
      my_session.MEMORY;
      sf_timer.start_timer;
   END;

   PROCEDURE transformative_pl
   IS
   BEGIN
      init;

      INSERT INTO tickertable
         SELECT *
           FROM TABLE (stockpivot_pl (CURSOR (SELECT *
                                                FROM stocktable)));

      my_session.MEMORY;
      sf_timer.show_elapsed_time ('All SQL with Pipelining function');
   -- showtabcount ('tickertable');
   END;

   PROCEDURE transformative_nopl
   IS
   BEGIN
      init;

      INSERT INTO tickertable
         SELECT *
           FROM TABLE (stockpivot_nopl (CURSOR (SELECT *
                                                  FROM stocktable)));

      my_session.MEMORY;
      sf_timer.show_elapsed_time ('All SQL with non-pipelining function');
   -- showtabcount ('tickertable');
   END;

   PROCEDURE intermediate_structure
   /*
   Use a nested table to retrieve the pivoted data
   and then transfer to the database table.
   */
   IS
      curvar    sys_refcursor;
      mystock   tickertypeset := tickertypeset ();
      indx      PLS_INTEGER;
   BEGIN
      init;

      OPEN curvar FOR
         SELECT *
           FROM stocktable;

      mystock := stockpivot_nopl (curvar);
      indx := mystock.FIRST;

      LOOP
         EXIT WHEN indx IS NULL;

         INSERT INTO tickertable
                     (ticker
                    , pricedate
                    , pricetype
                    , price
                     )
              VALUES (mystock (indx).ticker
                    , mystock (indx).pricedate
                    , mystock (indx).pricetype
                    , mystock (indx).price
                     );

         indx := mystock.NEXT (indx);
      END LOOP;

      my_session.MEMORY;
      sf_timer.show_elapsed_time ('Intermediate collection');
   -- showtabcount ('tickertable');
   END;

   PROCEDURE intermediate_forall_1
   /*
   Use a nested table to retrieve the pivoted data
   and then use FORALL to transfer to the database table.
   */
   IS
      curvar          sys_refcursor;
      mystock         tickertypeset  := tickertypeset ();

      TYPE tickertable_tt IS TABLE OF tickertable%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_tickertable   tickertable_tt;
   BEGIN
      init;

      OPEN curvar FOR
         SELECT *
           FROM stocktable;

      mystock := stockpivot_nopl (curvar);

      FOR indx IN mystock.FIRST .. mystock.LAST
      LOOP
         l_tickertable (indx).ticker := mystock (indx).ticker;
         l_tickertable (indx).pricedate := mystock (indx).pricedate;
         l_tickertable (indx).pricetype := mystock (indx).pricetype;
         l_tickertable (indx).price := mystock (indx).price;
      END LOOP;

      -- Inserting a record!
      FORALL indx IN l_tickertable.FIRST .. l_tickertable.LAST
         INSERT INTO tickertable
              VALUES l_tickertable (indx);
      my_session.MEMORY;
      sf_timer.show_elapsed_time ('Intermediate collection with FORALL-V1');
   -- showtabcount ('tickertable');
   END;

   PROCEDURE intermediate_forall_2
/*
Use BULK COLLECT and then FORALL to transfer to the database table.
*/
   IS
      TYPE stocktable_tt IS TABLE OF stocktable%ROWTYPE
         INDEX BY BINARY_INTEGER;

      TYPE tickertable_tt IS TABLE OF tickertable%ROWTYPE
         INDEX BY BINARY_INTEGER;

      l_stocktable    stocktable_tt;
      l_tickertable   tickertable_tt;
      l_index         PLS_INTEGER;
   BEGIN
      init;

      SELECT *
      BULK COLLECT INTO l_stocktable
        FROM stocktable;

      FOR indx IN l_stocktable.FIRST .. l_stocktable.LAST
      LOOP
         l_index := l_tickertable.COUNT + 1;
         l_tickertable (l_index).ticker := l_stocktable (indx).ticker;
         l_tickertable (l_index).pricedate := l_stocktable (indx).trade_date;
         l_tickertable (l_index).pricetype := 'O';
         l_tickertable (l_index).price := l_stocktable (indx).open_price;
         l_index := l_tickertable.COUNT + 1;
         l_tickertable (l_index).ticker := l_stocktable (indx).ticker;
         l_tickertable (l_index).pricedate := l_stocktable (indx).trade_date;
         l_tickertable (l_index).pricetype := 'C';
         l_tickertable (l_index).price := l_stocktable (indx).open_price;
      END LOOP;

      -- Inserting a record!
      FORALL indx IN l_tickertable.FIRST .. l_tickertable.LAST
         INSERT INTO tickertable
              VALUES l_tickertable (indx);
      my_session.MEMORY;
      sf_timer.show_elapsed_time ('Intermediate collection with FORALL-V2');
   -- showtabcount ('tickertable');
   END;

   PROCEDURE cursor_for_loop_breakout
   IS
-- The old-fashioned way
   BEGIN
      init;

      FOR rec IN (SELECT *
                    FROM stocktable)
      LOOP
         INSERT INTO tickertable
                     (ticker
                    , pricedate
                    , pricetype
                    , price
                     )
              VALUES (rec.ticker
                    , rec.trade_date
                    , 'O'
                    , rec.open_price
                     );

         INSERT INTO tickertable
                     (ticker
                    , pricedate
                    , pricetype
                    , price
                     )
              VALUES (rec.ticker
                    , rec.trade_date
                    , 'C'
                    , rec.close_price
                     );
      END LOOP;

      my_session.MEMORY;
      sf_timer.show_elapsed_time ('Cursor FOR Loop and two inserts');
   -- showtabcount ('tickertable');
   END;

   PROCEDURE first_ten_rows_pl
   IS
   BEGIN
      init;

      INSERT INTO tickertable
         SELECT *
           FROM TABLE (stockpivot_pl (CURSOR (SELECT *
                                                FROM stocktable)))
          WHERE ROWNUM < 10;

      my_session.MEMORY;
      sf_timer.show_elapsed_time ('Pipelining first 10 rows');
   -- showtabcount ('tickertable');
   END;

   PROCEDURE first_ten_rows_nopl
   IS
   BEGIN
      init;

      INSERT INTO tickertable
         SELECT *
           FROM TABLE (stockpivot_nopl (CURSOR (SELECT *
                                                  FROM stocktable)))
          WHERE ROWNUM < 10;

      my_session.MEMORY;
      sf_timer.show_elapsed_time ('NO pipelining first 10 rows');
   -- showtabcount ('tickertable');
   END;
BEGIN
   -- Compare stock pivot approaches
   cursor_for_loop_breakout;
   transformative_nopl;
   transformative_pl;
   intermediate_structure;
   intermediate_forall_1;
   intermediate_forall_2;
   --
   -- Compare "first 10 rows" performance
   first_ten_rows_pl;
   first_ten_rows_nopl;
/*
Some results:

Cursor FOR Loop and two inserts Elapsed: 31.65 seconds.
All SQL with non-pipelining function Elapsed: 15.79 seconds.
All SQL with Pipelining function Elapsed: 13.79 seconds.

Intermediate collection Elapsed: 39.94 seconds.
Intermediate collection with FORALL-V1 Elapsed: 17.56 seconds.
Intermediate collection with FORALL-V2 Elapsed: 8.06 seconds.

Pipelining first 10 rows Elapsed: .1 seconds.
NO pipelining first 10 rows Elapsed: 10.13 seconds.
*/
END;
/

EXEC pipeline_performance