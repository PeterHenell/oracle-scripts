/* Turn off substitutability for an entire table */

DROP TABLE brunches;

CREATE TABLE brunches OF food_t NOT SUBSTITUTABLE AT ALL LEVELS;

DECLARE
   l_name   VARCHAR2 (100);
BEGIN
   l_name := 'Eggs benedict';

   INSERT INTO brunches
        VALUES (food_t (l_name, 'PROTEIN', 'Farm'));

   l_name := 'Strawberries and cream';

   INSERT INTO brunches
        VALUES (dessert_t ('a', 'FRUIT', 'Backyard', 'N', 2001));
EXCEPTION
   WHEN OTHERS
   THEN
      IF SQLCODE = -932
      THEN
         DBMS_OUTPUT.put_line ('Inconsistent dataype with ' || l_name);
      ELSE
         RAISE;
      END IF;
END;
/

/* Turning off substitutability on a single column. */

DROP TABLE meal;

CREATE TABLE meal (
   served_on DATE,
   appetizer food_t,
   main_course food_t,
   dessert dessert_t
   )
   COLUMN appetizer NOT SUBSTITUTABLE AT ALL LEVELS;

BEGIN
   INSERT INTO meal
        VALUES (SYSDATE, food_t ('Shrimp cocktail', 'PROTEIN', 'Ocean')
              , food_t ('Eggs benedict', 'PROTEIN', 'Farm')
              , dessert_t ('Strawberries and cream'
                         , 'FRUIT'
                         , 'Backyard'
                         , 'N'
                         , 2001
                          ));

   -- Invalid substitution for appetizer.
   INSERT INTO meal
        VALUES (SYSDATE + 1
              , dessert_t ('Strawberries and cream'
                         , 'FRUIT'
                         , 'Backyard'
                         , 'N'
                         , 2001
                          )
              , food_t ('Eggs benedict', 'PROTEIN', 'Farm')
              , cake_t ('Apple Pie'
                      , 'FRUIT'
                      , 'Baker''s Square'
                      , 'N'
                      , 2001
                      , 8
                      , NULL
                       ));
EXCEPTION
   WHEN OTHERS
   THEN
      IF SQLCODE = -932
      THEN
         DBMS_OUTPUT.put_line ('Inconsistent dataype!');
      END IF;
END;
/

DROP TABLE meal;

CREATE TABLE meal (
   served_on DATE,
   appetizer food_t,
   main_course food_t,
   dessert dessert_t
   )
   COLUMN appetizer NOT SUBSTITUTABLE AT ALL LEVELS,
   COLUMN dessert IS OF (ONLY cake_t);

BEGIN
   -- This will no longer work.
   INSERT INTO meal
        VALUES (SYSDATE, food_t ('Shrimp cocktail', 'PROTEIN', 'Ocean')
              , food_t ('Eggs benedict', 'PROTEIN', 'Farm')
              , dessert_t ('Strawberries and cream'
                         , 'FRUIT'
                         , 'Backyard'
                         , 'N'
                         , 2001
                          ));
END;
/