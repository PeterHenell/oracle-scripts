CREATE OR REPLACE PACKAGE vocab1
IS 
   FUNCTION lookup (p_english IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2);
END vocab1;
/

CREATE OR REPLACE PACKAGE BODY vocab1
IS 
   FUNCTION lookup (p_english IN VARCHAR2)
      RETURN VARCHAR2
   IS 
      v_french   translations.french%TYPE;
   BEGIN
      SELECT french
        INTO v_french
        FROM translations
       WHERE english = p_english;

      RETURN v_french;
   END lookup;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2)
   IS
   BEGIN
      INSERT INTO translations
                  (english, french)
           VALUES (p_english, p_french);
   END new_pair;
END vocab1;
/
