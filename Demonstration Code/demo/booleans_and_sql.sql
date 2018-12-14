/* Assigning SQL value to Boolean */

CREATE TABLE plch_ratings
(
   title          VARCHAR2 (100)
 ,  is_fantastic   VARCHAR2 (5)
)
/

BEGIN
   INSERT INTO plch_ratings
        VALUES ('Casablanca', 'TRUE');

   INSERT INTO plch_ratings
        VALUES ('Battlefield Earth', 'FALSE');

   COMMIT;
END;
/

DECLARE
   l_result   BOOLEAN;
BEGIN
   SELECT is_fantastic
     INTO l_result
     FROM plch_ratings
    WHERE title = 'Casablanca';

   IF l_result
   THEN
      DBMS_OUTPUT.put_line ('Fantastic!');
   END IF;
END;
/

DECLARE
   l_result   BOOLEAN;
BEGIN
   SELECT DECODE (is_fantastic,  'TRUE', TRUE,  'FALSE', FALSE,  NULL)
     INTO l_result
     FROM plch_ratings
    WHERE title = 'Casablanca';

   IF l_result
   THEN
      DBMS_OUTPUT.put_line ('Fantastic!');
   END IF;
END;
/

DECLARE
   l_result   plch_ratings.is_fantastic%TYPE;
BEGIN
   SELECT is_fantastic
     INTO l_result
     FROM plch_ratings
    WHERE title = 'Casablanca';

   DBMS_OUTPUT.put_line (
      CASE l_result WHEN 'TRUE' THEN 'Fantastic!' ELSE NULL END);
END;
/

DECLARE
   l_result   BOOLEAN;
BEGIN
   SELECT CASE l_result WHEN 'TRUE' THEN TRUE ELSE FALSE END
     INTO l_result
     FROM plch_ratings
    WHERE title = 'Casablanca';

   IF l_result
   THEN
      DBMS_OUTPUT.put_line ('Fantastic!');
   END IF;
END;
/

DECLARE
   l_result           plch_ratings.is_fantastic%TYPE;
   l_boolean_result   BOOLEAN;
BEGIN
   SELECT CASE l_result WHEN 'TRUE' THEN TRUE ELSE FALSE END
     INTO l_result
     FROM plch_ratings
    WHERE title = 'Casablanca';

   l_boolean_result :=
      CASE l_result WHEN 'TRUE' THEN TRUE WHEN 'FALSE' THEN FALSE ELSE NULL END;

   IF l_boolean_result
   THEN
      DBMS_OUTPUT.put_line ('Fantastic!');
   END IF;
END;
/