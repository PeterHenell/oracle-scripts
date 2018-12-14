DROP TYPE my_dessert_t FORCE
/

DROP TYPE my_food_t FORCE
/

CREATE OR REPLACE TYPE my_food_t
AS
   OBJECT(
           name VARCHAR2( 100 ),
           food_group VARCHAR2( 100 ),
           grown_in VARCHAR2( 100 ),
           MEMBER FUNCTION price
              RETURN number,
           STATIC PROCEDURE healthy_reminder( hey_you_in IN CHAR ),
           CONSTRUCTOR FUNCTION my_food_t(
                                           SELF IN OUT my_food_t,
                                           NAME IN VARCHAR2
           )
              RETURN SELF AS RESULT
   )
   NOT FINAL;
/

CREATE OR REPLACE TYPE BODY my_food_t
AS
   MEMBER FUNCTION price
      RETURN number
   IS
   BEGIN
      RETURN 100;
   END price;

   STATIC PROCEDURE healthy_reminder( hey_you_in IN CHAR )
   IS
   BEGIN
      DBMS_OUTPUT.put_line(hey_you_in
                           || '! Eat lots of fresh fruits and vegetables!');
   END healthy_reminder;

   CONSTRUCTOR FUNCTION my_food_t( SELF IN OUT my_food_t, NAME IN VARCHAR2 )
      RETURN SELF AS RESULT
   IS
   BEGIN
      self.name   := name;
      RETURN;
   END my_food_t;
END;
/

CREATE OR REPLACE TYPE my_dessert_t
   UNDER my_food_t
   (
      contains_chocolate CHAR( 1 ),
      year_created NUMBER( 4 ),
      OVERRIDING MEMBER FUNCTION price
         RETURN number
   )
   NOT FINAL;
/

CREATE OR REPLACE TYPE BODY my_dessert_t
IS
   OVERRIDING MEMBER FUNCTION price
      RETURN NUMBER
   IS
      multiplier NUMBER := 1;
   BEGIN
      IF SELF.contains_chocolate = 'Y'
      THEN
         multiplier  := 2;
      END IF;

      IF SELF.year_created < 1900
      THEN
         multiplier  := multiplier + 0.5;
      END IF;

      RETURN ( 10.00 * multiplier );
   END price;
END;
/
