DROP TABLE sustenance;
DROP TABLE sweet_nothings;
DROP TABLE meals;
DROP TABLE brunches;
DROP TYPE dessert_t FORCE;
DROP TYPE cake_t FORCE;
DROP TYPE food_t FORCE;

CREATE TYPE food_t AS OBJECT (
   NAME         VARCHAR2 (100)
 , food_group   VARCHAR2 (100)
 , grown_in     VARCHAR2 (100)
 , ORDER MEMBER FUNCTION food_ordering (other_food_in IN food_t)
      RETURN INTEGER
)
NOT FINAL;
/

CREATE OR REPLACE TYPE BODY food_t
IS
   ORDER MEMBER FUNCTION food_ordering (other_food_in IN food_t)
      RETURN INTEGER
   /*
   Subtypes are always less.
   If of the same type, same rule as for MAP:
      Vegetable < Carbohydrate < Liquid < Protein
   */
   IS
      TYPE order_by_food_group_t IS TABLE OF PLS_INTEGER
         INDEX BY VARCHAR2 (100);

      l_order_by_food_group   order_by_food_group_t;
      c_self_eq_of   CONSTANT PLS_INTEGER           := 0;
      c_self_gt_of   CONSTANT PLS_INTEGER           := 1;
      c_of_gt_self   CONSTANT PLS_INTEGER           := -1;
      l_ordering              PLS_INTEGER           := c_self_eq_of;

      PROCEDURE initialize
      IS
      BEGIN
         l_order_by_food_group ('PROTEIN') := 1000;
         l_order_by_food_group ('LIQUID') := 100;
         l_order_by_food_group ('CARBOHYDRATE') := 10;
         l_order_by_food_group ('VEGETABLE') := 1;
      END initialize;
   BEGIN
      initialize;
      IF SELF IS OF (ONLY food_t)
      THEN
         l_ordering :=
            CASE
               WHEN other_food_in IS OF (ONLY food_t)
                  THEN c_self_eq_of
               ELSE c_self_gt_of
            END;
      ELSIF SELF IS OF (ONLY dessert_t)
      THEN
         l_ordering :=
            CASE
               WHEN other_food_in IS OF (ONLY dessert_t)
                  THEN c_self_eq_of
               WHEN other_food_in IS OF (ONLY food_t)
                  THEN c_of_gt_self 
               ELSE c_self_gt_of
            END;
      ELSE
         /* It is cake. */
         l_ordering :=
            CASE
               WHEN other_food_in IS OF (ONLY cake_t)
                  THEN c_self_eq_of
               ELSE c_of_gt_self
            END;
      END IF;

      IF l_ordering = c_self_eq_of
      THEN
         /*
         Further analysis is needed.
         */
         l_ordering :=
            CASE
               WHEN l_order_by_food_group (SELF.food_group) =
                             l_order_by_food_group (other_food_in.food_group)
                  THEN c_self_eq_of
               WHEN l_order_by_food_group (SELF.food_group) >
                             l_order_by_food_group (other_food_in.food_group)
                  THEN c_self_gt_of
               WHEN l_order_by_food_group (SELF.food_group) <
                             l_order_by_food_group (other_food_in.food_group)
                  THEN c_of_gt_self
            END;
      END IF;

      RETURN l_ordering;
   END;
END;
/

CREATE TYPE dessert_t UNDER food_t (
   contains_chocolate   CHAR (1)
 , year_created         NUMBER (4)
)
NOT FINAL;
/

CREATE TYPE cake_t UNDER dessert_t (
   diameter      NUMBER
 , inscription   VARCHAR2 (200)
)
;
/

CREATE TABLE meals (
   served_on DATE,
   appetizer food_t,
   main_course food_t,
   dessert dessert_t
   )
   COLUMN appetizer NOT SUBSTITUTABLE AT ALL LEVELS
/

BEGIN
   -- Populate the meal table
   INSERT INTO meals
        VALUES (SYSDATE, food_t ('Shrimp cocktail', 'PROTEIN', 'Ocean')
              , food_t ('Eggs benedict', 'PROTEIN', 'Farm')
              , dessert_t ('Strawberries and cream'
                         , 'FRUIT'
                         , 'Backyard'
                         , 'N'
                         , 2001
                          ));

   INSERT INTO meals
        VALUES (SYSDATE + 1, food_t ('Shrimp cocktail', 'PROTEIN', 'Ocean')
              , food_t ('Stir fry tofu', 'PROTEIN', 'Vat')
              , cake_t ('Apple Pie'
                      , 'FRUIT'
                      , 'Baker''s Square'
                      , 'N'
                      , 2001
                      , 8
                      , NULL
                       ));

   INSERT INTO meals
        VALUES (SYSDATE + 1, food_t ('Fried Calamari', 'PROTEIN', 'Ocean')
              , dessert_t ('Butter cookie', 'CARBOHYDRATE', 'Oven', 'N', 2001)
              , cake_t ('French Silk Pie'
                      , 'CARBOHYDRATE'
                      , 'Baker''s Square'
                      , 'Y'
                      , 2001
                      , 6
                      , 'To My Favorite Frenchman'
                       ));

   INSERT INTO meals
        VALUES (SYSDATE + 1, food_t ('Fried Calamari', 'PROTEIN', 'Ocean')
              , food_t ('Brussels Sprouts', 'VEGETABLE', 'Backyard')
              , dessert_t ('Butter cookie', 'CARBOHYDRATE', 'Oven', 'N', 2001));
END;
/

SELECT   TREAT (main_course AS food_t).NAME
    FROM meals
ORDER BY main_course
/

DECLARE
   ot1   food_t := food_t ('Eggs benedict', 'PROTEIN', 'Farm');
   ot2   food_t := food_t ('Brussels Sprouts', 'VEGETABLE', 'Backyard');
   ot3   food_t := food_t ('Brussels Sprouts', 'VEGETABLE', 'Backyard');
BEGIN
   IF ot1 = ot2
   THEN
      DBMS_OUTPUT.put_line ('equal - incorrect');
   ELSE
      DBMS_OUTPUT.put_line ('not equal - correct');
   END IF;

   IF ot2 <> ot3
   THEN
      DBMS_OUTPUT.put_line ('not equal - incorrect');
   ELSE
      DBMS_OUTPUT.put_line ('equal - correct');
   END IF;
END;
/