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

CREATE TYPE meals_vat IS VARRAY ( 3 ) OF meal_t;
/

DECLARE
   -- A locally-defined varray initialized with no elements.
   l_one_day_of_meals meals_vat := meals_vat ( );
BEGIN
   -- Make room for the three meals.
   l_one_day_of_meals.EXTEND ( 3 );
   -- Add breakfast, using the constructor for both the meal and within it
   -- the food object type instance.
   l_one_day_of_meals ( 1 ) :=
      meal_t ( 4, 'BREAKFAST'
             , food_t ( 'Scrambled Eggs', 'Protein', 'Yellow' ));
   -- Add lunch
   l_one_day_of_meals ( 2 ) :=
         meal_t ( 6, 'LUNCH', food_t ( 'Deluxe Salad', 'Vegetables', 'Green' ));
   -- Add dinner
   l_one_day_of_meals ( 3 ) :=
         meal_t ( 10, 'DINNER', food_t ( 'Tofu and Rice', 'Protein', 'White' ));
END;
/

DECLARE
   -- A locally-defined varray initialized with no elements.
   l_one_day_of_meals meals_vat
      := meals_vat ( meal_t ( 4
                            , 'BREAKFAST'
                            , food_t ( 'Scrambled Eggs', 'Protein', 'Yellow' )
                            )
                   );
BEGIN
   -- If more than 2 people are served, then show the name of the food.
   IF l_one_day_of_meals ( 1 ).number_served > 2
   THEN
      DBMS_OUTPUT.put_line ( l_one_day_of_meals ( 1 ).food_served.name );
   END IF;
END;
/
