CONNECT scott/tiger

CREATE OR REPLACE TYPE food_t AS OBJECT (
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
      DBMS_OUTPUT.PUT_LINE  ('SCOTT food price calculation!');
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

CREATE OR REPLACE PROCEDURE call_food_price
AUTHID CURRENT_USER
IS
   l   food_t := food_t ('apple', 'PROTEIN', 'US');
BEGIN
   DBMS_OUTPUT.put_line (l.price ());
END;
/

GRANT EXECUTE ON call_food_price TO hr
/

SET serveroutput on

BEGIN
   call_food_price ();
END;
/

CONNECT hr/hr

DROP TYPE food_t FORCE
/

CREATE OR REPLACE TYPE food_t AS OBJECT (
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
      DBMS_OUTPUT.PUT_LINE  ('HR food price calculation!');
      RETURN -100;
   END;
END;
/

SET serveroutput on

BEGIN
   scott.call_food_price ();
END;
/