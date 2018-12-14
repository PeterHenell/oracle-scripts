DROP TYPE food_t FORCE;

CREATE TYPE food_t AS OBJECT (
   NAME         VARCHAR2 (100)
 , food_group   VARCHAR2 (100)
 , grown_in     VARCHAR2 (100)
 , MEMBER FUNCTION price
      RETURN NUMBER
)
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

DROP TABLE food_table
/
CREATE TABLE food_table OF food_t
   (CONSTRAINT food_table_pk PRIMARY KEY (NAME))
/

BEGIN
   INSERT INTO food_table
        VALUES (NEW food_t ('Mutter Paneer', 'Curry', 'India'));

   INSERT INTO food_table
        VALUES (NEW food_t ('Cantaloupe', 'Fruit', 'Backyard'));

   COMMIT;
END;
/

SELECT *
  FROM food_table
/

BEGIN
   UPDATE food_table
      SET grown_in = 'Florida'
    WHERE NAME = 'Cantaloupe';
END;
/

SELECT *
  FROM food_table
/

SELECT REF (ft)
  FROM food_table ft
 WHERE NAME = 'Cantaloupe'
/

SELECT VALUE (ft).name
  FROM food_table ft
 WHERE NAME = 'Cantaloupe'
/