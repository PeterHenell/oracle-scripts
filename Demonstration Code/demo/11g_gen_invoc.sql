/*
Demonstration of Oracle 11g generalized invocation
*/

DROP TYPE cake_t FORCE;
DROP TYPE dessert_t FORCE;
DROP TYPE food_t FORCE;

CREATE TYPE food_t AS OBJECT
       (name VARCHAR2 (100)
      , food_group VARCHAR2 (100)
      , grown_in VARCHAR2 (100)
      , MEMBER FUNCTION to_string
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY food_t
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

CREATE TYPE dessert_t
          UNDER food_t
       (contains_chocolate CHAR (1)
      , OVERRIDING MEMBER FUNCTION to_string
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY dessert_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      /* Display the dessert information + food info. */

      RETURN 'DESSERT! Chocolate=' 
          || contains_chocolate 
          || ' ' 
          || (SELF as food_t).to_string   ;
   END;
END;
/

CREATE TYPE cake_t
          UNDER dessert_t
       (diameter NUMBER
      , OVERRIDING MEMBER FUNCTION to_string
           RETURN VARCHAR2);
/

CREATE OR REPLACE TYPE BODY cake_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      /* Call two supertype methods... */

      RETURN    'CAKE! Diameter='
             || self.diameter
             || ' '
             || (SELF as dessert_t).to_string;
   END;
END;
/

SET SERVEROUTPUT ON FORMAT WRAPPED

DECLARE
   TYPE foodstuffs_nt IS TABLE OF food_t;

   fridge_contents   foodstuffs_nt
      := foodstuffs_nt (food_t ('Eggs benedict', 'PROTEIN', 'Farm')
                      , dessert_t ('Strawberries and cream'
                                 , 'FRUIT'
                                 , 'Backyard'
                                 , 'N')
                      , cake_t ('Chocolate Supreme'
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

/* Now bypass dessert string */

CREATE OR REPLACE TYPE BODY cake_t
IS
   OVERRIDING MEMBER FUNCTION to_string
      RETURN VARCHAR2
   IS
   BEGIN
      /* Call two supertype methods... */

      RETURN    'CAKE! Diameter='
             || self.diameter
             || ' '
             || (SELF as food_t).to_string;
   END;
END;
/

DECLARE
   TYPE foodstuffs_nt IS TABLE OF food_t;

   fridge_contents   foodstuffs_nt
      := foodstuffs_nt (food_t ('Eggs benedict', 'PROTEIN', 'Farm')
                      , dessert_t ('Strawberries and cream'
                                 , 'FRUIT'
                                 , 'Backyard'
                                 , 'N')
                      , cake_t ('Chocolate Supreme'
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

