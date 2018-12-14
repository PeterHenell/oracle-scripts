CREATE TYPE plch_food_t AS OBJECT
(
   name VARCHAR2 (100),
   food_group VARCHAR2 (100),
   MAP MEMBER FUNCTION compare_foods
      RETURN NUMBER
)
   NOT FINAL;
/

CREATE OR REPLACE TYPE BODY plch_food_t
IS
   MAP MEMBER FUNCTION compare_foods
      RETURN NUMBER
   IS
   BEGIN
      RETURN (  CASE self.food_group
                   WHEN 'PROTEIN' THEN 300
                   WHEN 'CARBOHYDRATE' THEN 200
                   WHEN 'VEGETABLE' THEN 100
                END
              + LENGTH (self.name));
   END;
END;
/

/* Override the supertype MAP method, works fine. */

CREATE OR REPLACE TYPE plch_dessert_t
   UNDER plch_food_t
   (
      contains_nuts CHAR (1),
      OVERRIDING MAP MEMBER FUNCTION compare_foods
         RETURN NUMBER
   );
/

CREATE OR REPLACE TYPE BODY plch_dessert_t
IS
   OVERRIDING MAP MEMBER FUNCTION compare_foods
      RETURN NUMBER
   IS
   BEGIN
      RETURN (CASE self.contains_nuts
                 WHEN 'Y' THEN 400
                 ELSE 200
              END);
   END;
END;
/

DECLARE
   ot1   plch_food_t 
            := plch_food_t ('Eggs Benedict', 'PROTEIN');
   ot2   plch_food_t
            := plch_food_t ('Brussels Sprouts', 'VEGETABLE');
   ot3   plch_food_t
            := plch_dessert_t ('Brownie', 'PROTEIN', 'Y');
BEGIN
   DBMS_OUTPUT.put_line (
      CASE WHEN ot1 > ot2 THEN ot1.name ELSE ot2.name END);
   DBMS_OUTPUT.put_line (
      CASE WHEN ot1 > ot3 THEN ot1.name ELSE ot3.name END);
END;
/

/* No overriding of method */

CREATE OR REPLACE TYPE plch_dessert_t
   UNDER plch_food_t
   (contains_nuts CHAR (1));
/

DECLARE
   ot1   plch_food_t 
            := plch_food_t ('Eggs Benedict', 'PROTEIN');
   ot2   plch_food_t
            := plch_food_t ('Brussels Sprouts', 'VEGETABLE');
   ot3   plch_food_t
            := plch_dessert_t ('Brownie', 'PROTEIN', 'Y');
BEGIN
   DBMS_OUTPUT.put_line (
      CASE WHEN ot1 > ot2 THEN ot1.name ELSE ot2.name END);
   DBMS_OUTPUT.put_line (
      CASE WHEN ot1 > ot3 THEN ot1.name ELSE ot3.name END);
END;
/

/* Try to provide another MAP method for the subtype.
   No go: PLS-00638: cannot overload MAP method
*/

CREATE OR REPLACE TYPE plch_dessert_t
   UNDER plch_food_t
   (
      contains_nuts CHAR (1),
      MAP MEMBER FUNCTION dessert_mapping
         RETURN NUMBER
   );
/

CREATE OR REPLACE TYPE BODY plch_dessert_t
IS
   MAP MEMBER FUNCTION dessert_mapping
      RETURN NUMBER
   IS
   BEGIN
      RETURN (CASE self.contains_nuts
                 WHEN 'Y' THEN 400
                 ELSE 200
              END);
   END;
END;
/

DECLARE
   ot1   plch_food_t 
            := plch_food_t ('Eggs Benedict', 'PROTEIN');
   ot2   plch_food_t
            := plch_food_t ('Brussels Sprouts', 'VEGETABLE');
   ot3   plch_food_t
            := plch_dessert_t ('Brownie', 'PROTEIN', 'Y');
BEGIN
   DBMS_OUTPUT.put_line (
      CASE WHEN ot1 > ot2 THEN ot1.name ELSE ot2.name END);
   DBMS_OUTPUT.put_line (
      CASE WHEN ot1 > ot3 THEN ot1.name ELSE ot3.name END);
END;
/

/* Clean up */

DROP TYPE plch_food_t FORCE
/

DROP TYPE plch_dessert_t FORCE
/