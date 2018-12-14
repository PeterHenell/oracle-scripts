CREATE TYPE food_t AS OBJECT (
   name VARCHAR2 ( 100 )
 , food_group VARCHAR2 ( 100 )
 , color VARCHAR2 ( 100 )
);
/

CREATE TYPE meal_t AS OBJECT (
   number_served INTEGER
 , meal_type VARCHAR2 ( 100 )
 , food_served food_t
);
/

CREATE TYPE meals_nt IS TABLE OF meal_t;
/

drop TABLE all_my_meals 
/

CREATE TABLE all_my_meals (
   date_served DATE,
   name VARCHAR2(100),
   meals_served meals_nt 
) NESTED TABLE meals_served STORE AS i_meals_nt;
/
DELETE FROM all_my_meals
/

DECLARE
   -- A locally-defined varray initialized with no elements.
   l_one_day_of_meals meals_nt := meals_nt ( );
BEGIN
   -- Make room for the three meals.
   l_one_day_of_meals.EXTEND ( 3 );
   -- Add breakfast, using the constructor for both the meal
   -- and within it the food object type instance.
   l_one_day_of_meals ( 1 ) :=
      meal_t ( 4, 'BREAKFAST'
             , food_t ( 'Scrambled Eggs', 'Protein', 'Yellow' ));
   -- Add lunch
   l_one_day_of_meals ( 2 ) :=
      meal_t ( 6
             , 'LUNCH'
             , food_t ( 'Deluxe Salad', 'Vegetables', 'Mostly Green' )
             );
   -- Add dinner
   l_one_day_of_meals ( 3 ) :=
          meal_t ( 10, 'DINNER', food_t ( 'Tofu and Rice', 'Protein', 'White' ));

   -- Put the meal into the relational table.
   INSERT INTO all_my_meals
        VALUES ( SYSDATE, 'YumYum', l_one_day_of_meals );

   -- Change breakfast and dinner for the next night
   l_one_day_of_meals ( 3 ) :=
                 meal_t ( 4, 'BREAKFAST', food_t ( 'Donuts', 'Sugar', 'White' ));
   l_one_day_of_meals ( 3 ) :=
         meal_t ( 4, 'DINNER', food_t ( 'Big Thick Steak', 'Protein', 'Brown' ));

   INSERT INTO all_my_meals
        VALUES ( SYSDATE, 'Lumberjack', l_one_day_of_meals );

   COMMIT;
END;
/

SELECT ms.meal_type
  FROM TABLE ( SELECT meals_served
                 FROM all_my_meals
                WHERE name = 'YumYum' ) ms
/
SELECT ms.meal_type
  FROM TABLE ( SELECT meals_served
                 FROM all_my_meals
                WHERE name = 'YumYum' ) ms
 WHERE ms.number_served > 4
/
UPDATE TABLE ( SELECT meals_served
                 FROM all_my_meals
                WHERE name = 'YumYum' )
   SET number_served = 15
 WHERE meal_type = 'BREAKFAST'
/
SELECT ms.meal_type
     , ms.number_served
  FROM TABLE ( SELECT meals_served
                 FROM all_my_meals
                WHERE name = 'YumYum' ) ms
/
