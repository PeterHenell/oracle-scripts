REM @@food.ot

DROP TABLE meal;

CREATE TABLE meal (
   served_on DATE,
   appetizer food_t,
   main_course food_t,
   dessert dessert_t
   )
   COLUMN appetizer NOT SUBSTITUTABLE AT ALL LEVELS
   ;
   
BEGIN
   -- Populate the meal table
	INSERT INTO meal VALUES (
	   SYSDATE,
	   food_t ('Shrimp cocktail', 'PROTEIN', 'Ocean'),
	   food_t ('Eggs benedict', 'PROTEIN', 'Farm'),
	   dessert_t ('Strawberries and cream', 'FRUIT', 'Backyard', 'N', 2001));
		  
	INSERT INTO meal VALUES (
	   SYSDATE + 1,
	   food_t ('Shrimp cocktail', 'PROTEIN', 'Ocean'),
	   food_t ('Stir fry tofu', 'PROTEIN', 'Vat'),
	   cake_t ('Apple Pie', 'FRUIT', 'Baker''s Square', 'N', 2001, 8, NULL));
	   
	INSERT INTO meal VALUES (
	   SYSDATE + 1,
	   food_t ('Fried Calamari', 'PROTEIN', 'Ocean'),
	   dessert_t ('Butter cookie', 'CARBOHYDRATE', 'Oven', 'N', 2001),
	   cake_t ('French Silk Pie', 'CARBOHYDRATE', 'Baker''s Square', 'Y', 2001, 6, 
	      'To My Favorite Frenchman'));
       
	INSERT INTO meal VALUES (
	   SYSDATE + 1,
	   food_t ('Fried Calamari', 'PROTEIN', 'Ocean'),
      cake_t ('French Silk Pie', 'CARBOHYDRATE', 'Baker''s Square', 'Y', 2001, 6, 
	      'To My Favorite Frenchman'),
	   dessert_t ('Butter cookie', 'CARBOHYDRATE', 'Oven', 'N', 2001));           	   
END;
/	

/* Show all the meals in which a main course is a dessert */
SELECT * 
  FROM meal
 WHERE TREAT (main_course AS dessert_t) 
       IS NOT NULL;
	   
/* Will fail, since main_course is of food_t type */
SELECT main_course.contains_chocolate 
  FROM meal
 WHERE TREAT (main_course AS dessert_t) 
       IS NOT NULL;

/*  Now it will work, since I am treating main_course as a dessert */
SELECT TREAT (main_course AS dessert_t).contains_chocolate chocolatey,
       TREAT (main_course AS dessert_t).year_created
  FROM meal
 WHERE TREAT (main_course AS dessert_t) IS NOT NULL;
 
SELECT TREAT (main_course AS dessert_t)
  FROM meal
 WHERE TREAT (main_course AS dessert_t) IS NOT NULL;
  
/* Set to NULL any desserts that are not cakes... */
UPDATE meal
   SET dessert = TREAT (dessert AS cake_t); 

/*
DECLARE
   l_dessert food_t := food_t ('MMMM', 'ABC', 'DEF');
   l_contains_chocolate VARCHAR2(100);
BEGIN
   l_contains_chocolate := TREAT (l_dessert AS dessert_t).contains_chocolate;
END;
/
*/