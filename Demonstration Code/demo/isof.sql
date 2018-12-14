REM Demonstration of dynamic polymorphism

DROP TYPE cake_t FORCE;
DROP TYPE dessert_t FORCE;
DROP TYPE food_t FORCE;

CREATE TYPE food_t AS OBJECT (
   NAME         VARCHAR2 (100)
 , food_group   VARCHAR2 (100)
 , grown_in     VARCHAR2 (100)
 , MEMBER FUNCTION price
      RETURN NUMBER
)
NOT FINAL;
/

CREATE OR REPLACE TYPE BODY food_t
IS
   MEMBER FUNCTION price
      RETURN NUMBER
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('Food price!');
      RETURN (CASE SELF.food_group
                 WHEN 'PROTEIN'
                    THEN 3
                 WHEN 'CARBOHYDRATE'
                    THEN 2
                 WHEN 'VEGETABLE'
                    THEN 1
              END
             );
   END;
END;
/

CREATE TYPE dessert_t UNDER food_t (
   contains_chocolate   CHAR (1)
 , year_created         NUMBER (4)
 , OVERRIDING MEMBER FUNCTION price
      RETURN NUMBER
)
NOT FINAL;
/

CREATE OR REPLACE TYPE BODY dessert_t
IS
   OVERRIDING MEMBER FUNCTION price
      RETURN NUMBER
   IS
      multiplier   NUMBER := 1;
   BEGIN
      DBMS_OUTPUT.put_line ('Dessert price!');

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

-- The cake_t type has no distinct pricing calculator.
)
;
/

DECLARE
   TYPE foodstuffs_nt IS TABLE OF food_t;

   fridge_contents   foodstuffs_nt
      := foodstuffs_nt (food_t ('Eggs benedict', 'PROTEIN', 'Farm')
                      , dessert_t ('Strawberries and cream'
                                 , 'FRUIT'
                                 , 'Backyard'
                                 , 'N'
                                 , 2001
                                  )
                      , cake_t ('Chocolate Supreme'
                              , 'CARBOHYDATE'
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
      CASE
         WHEN fridge_contents (indx) IS OF (ONLY food_t)
         THEN
            DBMS_OUTPUT.put_line (   'Generic food named "'
                                  || fridge_contents (indx).NAME
                                  || '"'
                                 );
         WHEN fridge_contents (indx) IS OF (ONLY dessert_t)
         THEN
            DBMS_OUTPUT.put_line (   'Dessert named "'
                                  || fridge_contents (indx).NAME
                                  || '"'
                                 );
         WHEN fridge_contents (indx) IS OF (ONLY cake_t)
         THEN
            DBMS_OUTPUT.put_line (   'Cook named "'
                                  || fridge_contents (indx).NAME
                                  || '"'
                                 );
      END CASE;
   END LOOP;
END;
/