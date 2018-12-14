DROP TABLE plch_parts
/

CREATE TABLE plch_parts
(
   partnum     INTEGER PRIMARY KEY
 ,  partname    VARCHAR2 (100) UNIQUE
 ,  partprice   NUMBER NOT NULL
)
/

BEGIN
   INSERT INTO plch_parts
        VALUES (100, 'Mouse', 50);

   INSERT INTO plch_parts
        VALUES (200, 'Keyboard', 40);

   INSERT INTO plch_parts
        VALUES (300, 'Cable', 15);

   INSERT INTO plch_parts
        VALUES (400, 'USB Hub', 25);

   INSERT INTO plch_parts
        VALUES (500, 'Monitor', 100);

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE plch_show_prices
IS
BEGIN
   DBMS_OUTPUT.put_line ('Prices:');

   FOR rec IN (  SELECT *
                   FROM plch_parts
               ORDER BY partnum)
   LOOP
      DBMS_OUTPUT.put_line (
         rec.partnum || '-' || rec.partprice);
   END LOOP;

   ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE plch_reduce_price_by (
   discount_in   IN NUMBER
 ,  id1_in        IN INTEGER
 ,  id2_in        IN INTEGER)
IS
BEGIN
   UPDATE plch_parts
      SET partprice = partprice - discount_in
    WHERE partnum = id1_in OR partnum = id2_in;
END;
/

/* And now we need three */

CREATE OR REPLACE PROCEDURE plch_reduce_price_by (
   discount_in   IN NUMBER
 ,  id1_in        IN INTEGER
 ,  id2_in        IN INTEGER
 ,  id3_in        IN INTEGER)
IS
BEGIN
   UPDATE plch_parts
      SET partprice = partprice - discount_in
    WHERE    partnum = id1_in
          OR partnum = id2_in
          OR partnum = id3_in;
END;
/

BEGIN
   plch_reduce_price_by (10
                       ,  200
                       ,  400
                       ,  500);
   plch_show_prices;
END;
/

/* Use a record...not the best but.... */

CREATE OR REPLACE PACKAGE plch_input
IS
   TYPE ids_rt IS RECORD
   (
      id1   INTEGER
    ,  id2   INTEGER
    ,  id3   INTEGER
   );
END;
/

CREATE OR REPLACE PROCEDURE plch_reduce_price_by (
   discount_in   IN NUMBER
 ,  ids_in        IN plch_input.ids_rt)
IS
BEGIN
   UPDATE plch_parts
      SET partprice = partprice - discount_in
    WHERE    partnum = ids_in.id1
          OR partnum = ids_in.id2
          OR partnum = ids_in.id3;
END;
/

DECLARE
   l_ids   plch_input.ids_rt;
BEGIN
   l_ids.id1 := 200;
   l_ids.id2 := 400;
   l_ids.id3 := 500;

   plch_reduce_price_by (10, l_ids);
   plch_show_prices;
END;
/

/* And now an associative array */

CREATE OR REPLACE PACKAGE plch_input
IS
   TYPE ids_aat IS TABLE OF INTEGER
                      INDEX BY PLS_INTEGER;
END;
/

CREATE OR REPLACE PROCEDURE plch_reduce_price_by (
   discount_in   IN NUMBER
 ,  ids_in        IN plch_input.ids_aat)
IS
BEGIN
   FORALL indx IN 1 .. ids_in.COUNT
      UPDATE plch_parts
         SET partprice = partprice - discount_in
       WHERE partnum = ids_in (indx);
END;
/

DECLARE
   l_ids   plch_input.ids_aat;
BEGIN
   l_ids (1) := 200;
   l_ids (2) := 400;
   l_ids (3) := 500;

   plch_reduce_price_by (10, l_ids);
   plch_show_prices;
END;
/

/* And now a nested table */

CREATE OR REPLACE TYPE ids_nt IS TABLE OF INTEGER
/

CREATE OR REPLACE PROCEDURE plch_reduce_price_by (
   discount_in   IN NUMBER
 ,  ids_in        IN ids_nt)
IS
BEGIN
   UPDATE plch_parts
      SET partprice = partprice - discount_in
    WHERE partnum IN
             (SELECT COLUMN_VALUE FROM TABLE (ids_in));
END;
/

DECLARE
   l_ids   ids_nt := ids_nt (200, 400, 500);
BEGIN
   plch_reduce_price_by (10, l_ids);
   plch_show_prices;
END;
/

/* Dumb way to use collection */

CREATE OR REPLACE PACKAGE plch_input
IS
   TYPE ids_aat IS TABLE OF INTEGER
                      INDEX BY PLS_INTEGER;
END;
/

CREATE OR REPLACE PROCEDURE plch_reduce_price_by (
   discount_in   IN NUMBER
 ,  ids_in        IN plch_input.ids_aat)
IS
   l_where   VARCHAR2 (32767);
BEGIN
   FOR indx IN 1 .. ids_in.COUNT
   LOOP
      l_where :=
            l_where
         || CASE
               WHEN l_where IS NULL THEN ' WHERE '
               ELSE ' OR '
            END
         || 'partnum = '
         || ids_in (indx);
   END LOOP;

   EXECUTE IMMEDIATE
         'UPDATE plch_parts
      SET partprice = partprice - :discount'
      || l_where
      USING discount_in;
END;
/

DECLARE
   l_ids   plch_input.ids_aat;
BEGIN
   l_ids (1) := 200;
   l_ids (2) := 400;
   l_ids (3) := 500;

   plch_reduce_price_by (10, l_ids);
   plch_show_prices;
END;
/