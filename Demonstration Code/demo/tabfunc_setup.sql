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
        VALUES ('ORCL', SYSDATE, 11.5, 11);

   INSERT INTO stocktable
        VALUES ('QSFT', SYSDATE, 13.2, 13.8);

   INSERT INTO stocktable
        VALUES ('MSFT', SYSDATE, 27, 27.04);

   FOR indx IN 1 .. 100000
   LOOP
      -- Might as well be optimistic!
      INSERT INTO stocktable
           VALUES ('STK' || indx, SYSDATE, indx, indx + 15);
   END LOOP;

   COMMIT;
END;
/

CREATE TYPE tickertype AS OBJECT (
   ticker      VARCHAR2 (20)
  ,pricedate   DATE
  ,pricetype   VARCHAR2 (1)
  ,price       NUMBER
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
END refcur_pkg;
/
