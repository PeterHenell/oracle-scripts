DROP  TYPE tickertype FORCE;
DROP  TYPE tickertypeset FORCE;
DROP  TABLE stocktable;
DROP  TABLE tickertable;

CREATE TABLE timing (
   program_name VARCHAR2(100),
   start_time NUMBER,
   end_time NUMBER,
   ran_on DATE)
/
CREATE TABLE  stocktable (
  ticker VARCHAR2(20),
  trade_date DATE,
  open_price NUMBER,
  close_price NUMBER
);

BEGIN
   -- Populate the table.
   INSERT INTO stocktable
        VALUES ( 'ORCL', SYSDATE, 12.5, 12 );

   INSERT INTO stocktable
        VALUES ( 'QSFT', SYSDATE, 13.2, 13.8 );

   INSERT INTO stocktable
        VALUES ( 'MSFT', SYSDATE, 27, 27.04 );

   COMMIT;
END;
/

CREATE TABLE tickertable
(
  ticker VARCHAR2(20),
  pricedate DATE,
  pricetype VARCHAR2(1),
  price NUMBER
)
/
/* 
   Note: Must use a nested table or varray of objects
   for the return type of a pipelined function
*/

CREATE TYPE tickertype AS OBJECT (
   ticker VARCHAR2 ( 20 )
 , pricedate DATE
 , pricetype VARCHAR2 ( 1 )
 , price NUMBER
);
/

CREATE TYPE tickertypeset AS TABLE OF tickertype;
/

CREATE OR REPLACE PACKAGE refcur_pkg
IS
   TYPE refcur_t IS REF CURSOR
      RETURN stocktable%ROWTYPE;
END refcur_pkg;
/

CREATE OR REPLACE FUNCTION stockpivot ( dataset refcur_pkg.refcur_t )
   RETURN tickertypeset
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_row_as_object tickertype := tickertype ( NULL, NULL, NULL, NULL );
   l_row_from_query dataset%ROWTYPE;
   retval tickertypeset := tickertypeset ( );
   --
   l_start NUMBER := DBMS_UTILITY.get_cpu_time;
   l_end NUMBER;
BEGIN
   LOOP
      FETCH dataset
       INTO l_row_from_query;

      EXIT WHEN dataset%NOTFOUND;
      --
      l_row_as_object.ticker := l_row_from_query.ticker;
      l_row_as_object.pricetype := 'O';
      l_row_as_object.price := l_row_from_query.open_price;
      l_row_as_object.pricedate := l_row_from_query.trade_date;
      retval.EXTEND;
      retval ( retval.LAST ) := l_row_as_object;
      --
      l_row_as_object.pricetype := 'C';
      l_row_as_object.price := l_row_from_query.close_price;
      l_row_as_object.pricedate := l_row_from_query.trade_date;
      retval.EXTEND;
      retval ( retval.LAST ) := l_row_as_object;
   END LOOP;

   CLOSE dataset;

   l_end := DBMS_UTILITY.get_cpu_time;

   INSERT INTO timing
        VALUES ( 'stockpivot', l_start, l_end, SYSDATE );

   COMMIT;
   RETURN retval;
END stockpivot;
/

BEGIN
   INSERT INTO tickertable
      SELECT *
        FROM TABLE ( stockpivot ( CURSOR ( SELECT *
                                             FROM stocktable )));
END;
/
