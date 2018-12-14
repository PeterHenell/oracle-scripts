DROP TABLE sweet_nothings
/

DROP TYPE dessert_t FORCE
/

DROP TYPE cake_t FORCE
/

DROP TYPE food_t FORCE
/

CREATE TYPE food_t AS OBJECT
       (name VARCHAR2 (100)
      , food_group VARCHAR2 (100)
      , grown_in VARCHAR2 (100))
          NOT FINAL;
/

CREATE TYPE dessert_t
          UNDER food_t
       (contains_chocolate CHAR (1), year_created NUMBER (4))
          NOT FINAL;
/

CREATE TYPE cake_t
          UNDER dessert_t
       (diameter NUMBER, inscription VARCHAR2 (200));
/

CREATE TABLE sweet_nothings OF dessert_t
/

BEGIN
   INSERT INTO sweet_nothings
        VALUES (dessert_t ('Jello'
                         , 'PROTEIN'
                         , 'bowl'
                         , 'N'
                         , 1887));

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

BEGIN
   INSERT INTO sweet_nothings
        VALUES (cake_t ('Marzepan Delight'
                      , 'CARBOHYDRATE'
                      , 'bakery'
                      , 'N'
                      , 1634
                      , 8
                      , 'Happy Birthday!'));

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

BEGIN
   INSERT INTO sweet_nothings
        VALUES (food_t ('Brussel Sprouts', 'VEGETABLE', 'farm'));

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/