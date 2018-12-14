/*
Demonstration of dynamic polymorphism:

Just one price method defined in the root type, food_t.
It calls a non-instantiable price_adjustment function.
This function is ONLY defined in each subtype.

*/

DROP TYPE cake_t FORCE;
DROP TYPE dessert_t FORCE;
DROP TYPE food_t FORCE;

CREATE TYPE food_t AS OBJECT (
   NAME         VARCHAR2 (100)
 , food_group   VARCHAR2 (100)
 , grown_in     VARCHAR2 (100)
 , NOT INSTANTIABLE MEMBER FUNCTION price_adjustment
      RETURN NUMBER
 , FINAL MEMBER FUNCTION price
      RETURN NUMBER
)
NOT FINAL NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE BODY food_t
IS
   FINAL MEMBER FUNCTION price
      RETURN NUMBER
   IS
      l_base_price   NUMBER
         := CASE SELF.food_group
         WHEN 'PROTEIN'
            THEN 3
         WHEN 'CARBOHYDRATE'
            THEN 2
         WHEN 'VEGETABLE'
            THEN 1
         WHEN 'FRUIT'
            THEN 1
      END;
      l_adjustment   NUMBER := price_adjustment ();
   BEGIN
      DBMS_OUTPUT.put_line ('Calculating price of food:');
      DBMS_OUTPUT.put_line ('Base = ' || l_base_price);
      DBMS_OUTPUT.put_line ('Adjustment = ' || l_adjustment);
      RETURN (l_adjustment + l_base_price);
   END;
END;
/

CREATE TYPE dessert_t UNDER food_t (
   contains_chocolate   CHAR (1)
 , year_created         NUMBER (4)
 , OVERRIDING MEMBER FUNCTION price_adjustment
      RETURN NUMBER
)
NOT FINAL;
/

CREATE OR REPLACE TYPE BODY dessert_t
IS
   OVERRIDING MEMBER FUNCTION price_adjustment
      RETURN NUMBER
   IS
      multiplier   NUMBER := 1;
   BEGIN
      DBMS_OUTPUT.put_line ('Adjust for DESSERT');

      IF SELF.contains_chocolate = 'Y'
      THEN
         multiplier := 2;
      END IF;

      IF SELF.year_created < 1900
      THEN
         multiplier := multiplier + 0.5;
      END IF;

      RETURN (10.00 * multiplier);
   END;
END;
/

CREATE TYPE cake_t UNDER dessert_t (
   diameter      NUMBER
 , inscription   VARCHAR2 (200)
 , OVERRIDING MEMBER FUNCTION price_adjustment
      RETURN NUMBER
)
;
/

CREATE OR REPLACE TYPE BODY cake_t
IS
   OVERRIDING MEMBER FUNCTION price_adjustment
      RETURN NUMBER
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('Adjust for CAKE');
      RETURN (  5.00                                             -- base price
              + 0.25 * (LENGTH (SELF.inscription))          -- $.25 per letter
              + 0.50 * diameter
             );
   END;
END;
/

DECLARE
   TYPE foodstuffs_nt IS TABLE OF food_t;

   fridge_contents   foodstuffs_nt
      := foodstuffs_nt (dessert_t ('Strawberries and cream'
                                 , 'FRUIT'
                                 , 'Backyard'
                                 , 'N'
                                 , 2001
                                  )
                      , cake_t ('Chocolate Supreme'
                              , 'CARBOHYDRATE'
                              , 'Kitchen'
                              , 'Y'
                              , 2001
                              , 8
                              , 'Happy Birthday, Veva'
                               )
                       );
BEGIN
   FOR indx IN fridge_contents.FIRST .. fridge_contents.LAST
   LOOP
      DBMS_OUTPUT.put_line (RPAD ('=', 60, '='));
      DBMS_OUTPUT.put_line (   'Price of '
                            || fridge_contents (indx).NAME
                            || ' = '
                            || fridge_contents (indx).price()
                           );
   END LOOP;
END;
/