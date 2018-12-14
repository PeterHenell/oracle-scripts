DROP TYPE food_class_t FORCE;

CREATE TYPE food_class_t AS OBJECT (
   food_NAME         VARCHAR2 (100)
 , food_class_ref REF food_class_t
)
/

DROP TABLE food_classes
/

CREATE TABLE food_classes OF food_class_t
   (CONSTRAINT food_classes_pk PRIMARY KEY (food_NAME)
    constraint food_classes_self_ref foreign key (food_class_ref )
    references food_classes);
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