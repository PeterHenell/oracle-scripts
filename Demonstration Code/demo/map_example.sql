DROP TABLE sustenance;
DROP TABLE sweet_nothings;
DROP TABLE meals;
DROP TABLE brunches;
DROP TYPE dessert_t FORCE;
DROP TYPE cake_t FORCE;
DROP TYPE food_t FORCE;

CREATE TYPE food_t AS OBJECT
	(name VARCHAR2 (100)
  , food_group VARCHAR2 (100)
  , grown_in VARCHAR2 (100)
  , MAP MEMBER FUNCTION food_mapping
		 RETURN NUMBER
	)
	NOT FINAL;
/

CREATE OR REPLACE TYPE BODY food_t
IS
	MAP MEMBER FUNCTION food_mapping
		RETURN NUMBER
	IS
	BEGIN
		RETURN (CASE self.food_group
					  WHEN 'PROTEIN' THEN 30000
					  WHEN 'LIQUID' THEN 20000
					  WHEN 'CARBOHYDRATE' THEN 15000
					  WHEN 'VEGETABLE' THEN 10000
				  END
				  + LENGTH (self.name));
	END;
END;
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

CREATE TABLE meals
(
	served_on	  DATE
 , appetizer	  food_t
 , main_course   food_t
 , dessert		  dessert_t
)
COLUMN appetizer NOT SUBSTITUTABLE AT ALL LEVELS
/

BEGIN
	-- Populate the meal table
	INSERT INTO meals
		 VALUES (
						SYSDATE
					 , food_t ('Shrimp cocktail', 'PROTEIN', 'Ocean')
					 , food_t ('Eggs benedict', 'PROTEIN', 'Farm')
					 , dessert_t ('Strawberries and cream'
									, 'FRUIT'
									, 'Backyard'
									, 'N'
									, 2001
									 )
				  );

	INSERT INTO meals
		 VALUES (
						SYSDATE + 1
					 , food_t ('Shrimp cocktail', 'PROTEIN', 'Ocean')
					 , food_t ('Stir fry tofu', 'PROTEIN', 'Vat')
					 , cake_t ('Apple Pie'
								, 'FRUIT'
								, 'Baker''s Square'
								, 'N'
								, 2001
								, 8
								, NULL
								 )
				  );

	INSERT INTO meals
		 VALUES (
						SYSDATE + 1
					 , food_t ('Fried Calamari', 'PROTEIN', 'Ocean')
					 , dessert_t ('Butter cookie'
									, 'CARBOHYDRATE'
									, 'Oven'
									, 'N'
									, 2001
									 )
					 , cake_t ('French Silk Pie'
								, 'CARBOHYDRATE'
								, 'Baker''s Square'
								, 'Y'
								, 2001
								, 6
								, 'To My Favorite Frenchman'
								 )
				  );

	INSERT INTO meals
		 VALUES (SYSDATE + 1
				 , food_t ('Fried Calamari', 'PROTEIN', 'Ocean')
				 , food_t ('Brussels Sprouts', 'VEGETABLE', 'Backyard')
				 , dessert_t ('Butter cookie', 'CARBOHYDRATE', 'Oven', 'N', 2001)
				  );

	COMMIT;
END;
/

  SELECT TREAT (main_course AS food_t).name
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
