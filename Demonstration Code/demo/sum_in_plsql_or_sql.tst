DROP TYPE numbers_t FORCE
/

CREATE OR REPLACE TYPE numbers_t IS TABLE OF NUMBER
/

DROP TYPE tickertype FORCE
/

DROP TYPE tickertypes_t FORCE
/

CREATE TYPE tickertype AS OBJECT
(
   ticker VARCHAR2 (20),
   pricedate DATE,
   pricetype VARCHAR2 (1),
   price NUMBER
);
/

CREATE TYPE tickertypes_t AS TABLE OF tickertype;
/

DECLARE
   l         INTEGER := 0;
   list      numbers_t := numbers_t ();
   tickers   tickertypes_t := tickertypes_t ();
BEGIN
   /* Single column */
   list.EXTEND (1000000);

   FOR i IN 1 .. 1000000
   LOOP
      list (i) := i;
   END LOOP;

   sf_timer.start_timer;

   FOR i IN 1 .. list.COUNT
   LOOP
      l := l + list (i);
   END LOOP;

   sf_timer.show_elapsed_time ('PL/SQL SUM');
   --
   sf_timer.start_timer;

   SELECT SUM (COLUMN_VALUE) INTO l FROM TABLE (list);

   sf_timer.show_elapsed_time ('SQL SUM');

   list.delete;

   DBMS_SESSION.free_unused_user_memory;

   /* Column of object type */

   tickers.EXTEND (1000000);

   FOR i IN 1 .. 1000000
   LOOP
      tickers (i) :=
         tickertype ('abc',
                        SYSDATE,
                        'O',
                        i);
   END LOOP;

   sf_timer.start_timer;

   FOR i IN 1 .. list.COUNT
   LOOP
      l := l + tickers (i).price;
   END LOOP;

   sf_timer.show_elapsed_time ('PL/SQL SUM');
   --
   sf_timer.start_timer;

   SELECT SUM (price) INTO l FROM TABLE (tickers);

   sf_timer.show_elapsed_time ('SQL SUM');

   tickers.delete;

   DBMS_SESSION.free_unused_user_memory;
END;
/