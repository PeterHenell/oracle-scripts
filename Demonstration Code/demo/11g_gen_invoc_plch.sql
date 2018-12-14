/*
Demonstration of Oracle 11g generalized invocation
*/

DROP TYPE plch_cake_t FORCE;
DROP TYPE plch_dessert_t FORCE;
DROP TYPE plch_food_t FORCE;

CREATE TYPE plch_food_t AS OBJECT
       (name VARCHAR2 (100)
      , food_group VARCHAR2 (100)
      , grown_in VARCHAR2 (100)
      , MEMBER FUNCTION to_string
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY plch_food_t
IS
   MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    'FOOD! '
             || self.name
             || '-'
             || self.food_group
             || '-'
             || self.grown_in;
   END;
END;
/

CREATE TYPE plch_dessert_t
          UNDER plch_food_t
       (contains_chocolate CHAR (1)
      , OVERRIDING MEMBER FUNCTION to_string
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY plch_dessert_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'DESSERT! Chocolate=' 
          || self.contains_chocolate 
          || ' ' 
          || (SELF as plch_food_t).to_string   ;
   END;
END;
/

CREATE TYPE plch_cake_t
          UNDER plch_dessert_t
       (diameter NUMBER
      , OVERRIDING MEMBER FUNCTION to_string
           RETURN VARCHAR2);
/

CREATE OR REPLACE TYPE BODY plch_cake_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    'CAKE! Diameter='
             || self.diameter
             || ' '
             || (SELF as plch_dessert_t).to_string;
   END;
END;
/

SET SERVEROUTPUT ON FORMAT WRAPPED

DECLARE
   TYPE foodstuffs_nt IS TABLE OF plch_food_t;

   fridge_contents   foodstuffs_nt
      := foodstuffs_nt (plch_food_t ('Eggs benedict', 'PROTEIN', 'Farm')
                      , plch_dessert_t ('Strawberries and cream'
                                 , 'FRUIT'
                                 , 'Backyard'
                                 , 'N')
                      , plch_cake_t ('Chocolate Supreme'
                              , 'CARBOHYDATE'
                              , 'Kitchen'
                              , 'Y'
                              , 8));
BEGIN
   FOR indx IN fridge_contents.FIRST .. fridge_contents.LAST
   LOOP
      DBMS_OUTPUT.put_line (fridge_contents (indx).to_string);
   END LOOP;
END;
/

/* Now show how it can be done (clumsily) through a package */

CREATE OR REPLACE PACKAGE plch_foods
IS
   FUNCTION food_string (food_in IN plch_food_t)
      RETURN VARCHAR2;

   FUNCTION dessert_string (dessert_in IN plch_dessert_t)
      RETURN VARCHAR2;

   FUNCTION cake_string (cake_in IN plch_cake_t)
      RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_foods
IS
   FUNCTION food_string (food_in IN plch_food_t)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    'FOOD! '
             || food_in.name
             || '-'
             || food_in.food_group
             || '-'
             || food_in.grown_in;
   END;

   FUNCTION dessert_string (dessert_in IN plch_dessert_t)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    'DESSERT! Chocolate='
             || dessert_in.contains_chocolate;
   END;

   FUNCTION cake_string (cake_in IN plch_cake_t)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'CAKE! Diameter=' || cake_in.diameter;
   END;
END;
/

DROP TYPE plch_cake_t FORCE;
DROP TYPE plch_dessert_t FORCE;
DROP TYPE plch_food_t FORCE;

CREATE TYPE plch_food_t AS OBJECT
       (name VARCHAR2 (100)
      , food_group VARCHAR2 (100)
      , grown_in VARCHAR2 (100)
      , MEMBER FUNCTION to_string
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY plch_food_t
IS
   MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN plch_foods.food_string (self);
   END;
END;
/

CREATE TYPE plch_dessert_t
          UNDER plch_food_t
       (contains_chocolate CHAR (1)
      , OVERRIDING MEMBER FUNCTION to_string
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY plch_dessert_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    plch_foods.food_string (self)
             || ' '
             || plch_foods.dessert_string (self);
   END;
END;
/

CREATE TYPE plch_cake_t
          UNDER plch_dessert_t
       (diameter NUMBER
      , OVERRIDING MEMBER FUNCTION to_string
           RETURN VARCHAR2);
/

CREATE OR REPLACE TYPE BODY plch_cake_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    plch_foods.food_string (self)
             || ' '
             || plch_foods.dessert_string (self)
             || ' '
             || plch_foods.cake_string (self);
   END;
END;
/

SET SERVEROUTPUT ON FORMAT WRAPPED

DECLARE
   TYPE foodstuffs_nt IS TABLE OF plch_food_t;

   fridge_contents   foodstuffs_nt
      := foodstuffs_nt (plch_food_t ('Eggs benedict', 'PROTEIN', 'Farm')
                      , plch_dessert_t ('Strawberries and cream'
                                      , 'FRUIT'
                                      , 'Backyard'
                                      , 'N')
                      , plch_cake_t ('Chocolate Supreme'
                                   , 'CARBOHYDATE'
                                   , 'Kitchen'
                                   , 'Y'
                                   , 8));
BEGIN
   FOR indx IN fridge_contents.FIRST .. fridge_contents.LAST
   LOOP
      DBMS_OUTPUT.put_line (fridge_contents (indx).to_string);
   END LOOP;
END;
/

/* Use wrong syntax for general invocation */

DROP TYPE plch_cake_t FORCE;
DROP TYPE plch_dessert_t FORCE;
DROP TYPE plch_food_t FORCE;

CREATE TYPE plch_food_t AS OBJECT
       (name VARCHAR2 (100)
      , food_group VARCHAR2 (100)
      , grown_in VARCHAR2 (100)
      , MEMBER FUNCTION to_string
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY plch_food_t
IS
   MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    'FOOD! '
             || self.name
             || '-'
             || self.food_group
             || '-'
             || self.grown_in;
   END;
END;
/

CREATE TYPE plch_dessert_t
          UNDER plch_food_t
       (contains_chocolate CHAR (1)
      , OVERRIDING MEMBER FUNCTION to_string
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY plch_dessert_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'DESSERT! Chocolate=' 
          || self.contains_chocolate 
          || ' ' 
          || super.to_string   ;
   END;
END;
/

CREATE TYPE plch_cake_t
          UNDER plch_dessert_t
       (diameter NUMBER
      , OVERRIDING MEMBER FUNCTION to_string
           RETURN VARCHAR2);
/

CREATE OR REPLACE TYPE BODY plch_cake_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    'CAKE! Diameter='
             || self.diameter
             || ' '
             || super.to_string;
   END;
END;
/

SET SERVEROUTPUT ON FORMAT WRAPPED

DECLARE
   TYPE foodstuffs_nt IS TABLE OF plch_food_t;

   fridge_contents   foodstuffs_nt
      := foodstuffs_nt (plch_food_t ('Eggs benedict', 'PROTEIN', 'Farm')
                      , plch_dessert_t ('Strawberries and cream'
                                 , 'FRUIT'
                                 , 'Backyard'
                                 , 'N')
                      , plch_cake_t ('Chocolate Supreme'
                              , 'CARBOHYDATE'
                              , 'Kitchen'
                              , 'Y'
                              , 8));
BEGIN
   FOR indx IN fridge_contents.FIRST .. fridge_contents.LAST
   LOOP
      DBMS_OUTPUT.put_line (fridge_contents (indx).to_string);
   END LOOP;
END;
/