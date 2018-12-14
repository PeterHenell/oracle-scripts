DROP TYPE plch_food_t FORCE
/

DROP TABLE plch_food
/

CREATE TYPE plch_food_t AS OBJECT (name VARCHAR2 (100));
/

CREATE or replace TYPE plch_food_nt IS TABLE OF VARCHAR2 (100)
/

CREATE TABLE plch_food (name VARCHAR2 (100))
/

CREATE OR REPLACE PACKAGE plch_pkg
IS
   TYPE food_rt IS RECORD (name VARCHAR2 (100));
END;
/

/* Can reference column of table */

DECLARE
   l_var   plch_food.name%TYPE := 'Brussels Sprouts';
BEGIN
   DBMS_OUTPUT.put_line (l_var);
END;
/

/* Can't reference nested table */

DECLARE
   l_var   plch_food_nt%TYPE := 'Brussels Sprouts';
BEGIN
   DBMS_OUTPUT.put_line (l_var);
END;
/

/* Can't reference an attribute of a type. */

DECLARE
   l_var   plch_food_t.name%TYPE := 'Brussels Sprouts';
BEGIN
   DBMS_OUTPUT.put_line (l_var);
END;
/

/* Instead, you must declare an OT instance and then reference attribute
   of that instance. */

DECLARE
   l_ot    plch_food_t := plch_food_t (NULL);
   l_var   l_ot.name%TYPE := 'Brussels Sprouts';
BEGIN
   DBMS_OUTPUT.put_line (l_var);
END;
/

/* Can't reference a field of a record type. */

DECLARE
   l_var   plch_pkg.food_rt.name%TYPE := 'Brussels Sprouts';
BEGIN
   DBMS_OUTPUT.put_line (l_var);
END;
/

/* Instead, you must declare a record and then reference field
   of that record variable */

DECLARE
   l_food   plch_pkg.food_rt;
   l_var    l_food.name%TYPE := 'Brussels Sprouts';
BEGIN
   DBMS_OUTPUT.put_line (l_var);
END;
/