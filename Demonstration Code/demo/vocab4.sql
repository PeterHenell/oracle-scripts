CREATE OR REPLACE PACKAGE vocab4
IS 
   FUNCTION lookup (p_english IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2);
END vocab4;
/

CREATE OR REPLACE PACKAGE BODY vocab4
-- Using the 9i VARCHAR2 associative array
IS 
   TYPE word_list IS TABLE OF translations.french%TYPE
      INDEX BY translations.english%type;
   g_english_french   word_list;

   FUNCTION lookup (p_english IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_english_french (p_english);
   END lookup;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2)
   IS
   BEGIN
      g_english_french (p_english) := p_french;

      INSERT INTO translations
                  (english, french)
           VALUES (p_english, p_french);
   END new_pair;

BEGIN                                               /* package initialization */
   FOR j IN (SELECT english, french
               FROM translations)
   LOOP
      g_english_french (j.english) := j.french;
   END LOOP;
END vocab4;
/
