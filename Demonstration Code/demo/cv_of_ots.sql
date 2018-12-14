CREATE TYPE food_t AS OBJECT
(
   name VARCHAR2 (100),
   food_group VARCHAR2 (100),
   MAP MEMBER FUNCTION food_mapping
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
      RETURN (  CASE self.food_group
                   WHEN 'PROTEIN' THEN 30000
                   WHEN 'LIQUID' THEN 20000
                   WHEN 'CARBOHYDRATE' THEN 15000
                   WHEN 'VEGETABLE' THEN 10000
                END
              + LENGTH (self.name));
   END;
END;
/

CREATE TABLE food_table
(
   n           NUMBER,
   food_info   food_t
)
/

BEGIN
   INSERT INTO food_table
        VALUES (100, food_t ('Chocolate', 'Fun'));

   INSERT INTO food_table
        VALUES (100, food_t ('Broccoli', 'Veggies'));

   COMMIT;
END;
/

CREATE OR REPLACE TYPE nt_of_ots IS TABLE OF food_t
/

CREATE OR REPLACE FUNCTION func_cv
   RETURN SYS_REFCURSOR
IS
   CV   SYS_REFCURSOR;
BEGIN
   OPEN CV FOR
      SELECT food_info /*t.food_info.name, t.food_info.food_group*/
        FROM food_table t;

   RETURN CV;
END;
/ 

/* Construct a query returning OTs of interest */

CREATE OR REPLACE FUNCTION nt_of_ots_func
   RETURN nt_of_ots
IS
   l_return   nt_of_ots;
BEGIN
   SELECT food_info
     BULK COLLECT INTO l_return
     FROM food_table t;

   RETURN l_return;
END;
/

/* Construct a query returning OTs of interest */

/* The current user code */

CREATE OR REPLACE FUNCTION cv_of_ots_func
   RETURN SYS_REFCURSOR
IS
   l_return   SYS_REFCURSOR;
BEGIN
   OPEN l_return FOR
      SELECT food_info
        FROM food_table t;

   RETURN l_return;
END;
/

/* Encapsulate */

CREATE OR REPLACE FUNCTION cv_of_ots_func
   RETURN SYS_REFCURSOR
IS
   l_return   SYS_REFCURSOR;
BEGIN
   OPEN l_return FOR
      SELECT food_info
        FROM food_table t;

   RETURN l_return;
END;
/

/* Use the CV function */

DECLARE
   CV   SYS_REFCURSOR;
   r    food_table.food_info%TYPE;
BEGIN
   CV := func_cv;

   LOOP
      FETCH CV INTO r;

      EXIT WHEN CV%NOTFOUND;
      DBMS_OUTPUT.put_line (r.name);
   END LOOP;
END;
/

/* Use the table function */

BEGIN
   FOR r IN (SELECT * FROM TABLE (nt_of_ots_func))
   LOOP
      DBMS_OUTPUT.put_line (r.name);
   END LOOP;
END;
/

/*
DROP TYPE food_t FORCE
/

DROP TABLE food_table
/

DROP FUNCTION func_cv
/

DROP TYPE nt_of_ots
/
*/