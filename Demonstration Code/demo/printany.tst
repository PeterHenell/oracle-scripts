BEGIN
   DBMS_OUTPUT.put_line (any_pkg.anytostring (anydata.convertdate (SYSDATE)));
END;
/

DROP TYPE food_t FORCE
/

CREATE TYPE food_t AS OBJECT
       (name VARCHAR2 (100)
      , food_group VARCHAR2 (100)
      , grown_in VARCHAR2 (100)
      , MEMBER FUNCTION tostring
           RETURN VARCHAR2)
          NOT FINAL;
/

CREATE OR REPLACE TYPE BODY food_t
IS
   MEMBER FUNCTION tostring
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN    self.food_group
             || ' '
             || self.name
             || ' grown in '
             || self.grown_in;
   END;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      any_pkg.anytostring (
         anydata.convertobject (NEW food_t ('Gumdrops', 'Candy', 'Factory'))));
END;
/