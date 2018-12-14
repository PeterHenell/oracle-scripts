CREATE OR REPLACE PACKAGE vocab5
IS 
   TYPE word_list IS TABLE OF translations.french%TYPE
      INDEX BY translations.english%type;
   lookup word_list;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2);
END vocab5;
/

CREATE OR REPLACE PACKAGE BODY vocab5
IS 
   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2)
   IS
   BEGIN
      lookup (p_english) := p_french;

      INSERT INTO translations
                  (english, french)
           VALUES (p_english, p_french);
   END new_pair;

BEGIN                                               /* package initialization */
   FOR j IN (SELECT english, french
               FROM translations)
   LOOP
      lookup (j.english) := j.french;
   END LOOP;
END vocab5;
/
