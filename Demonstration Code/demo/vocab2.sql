CREATE OR REPLACE PACKAGE vocab2
IS 
   FUNCTION lookup_for (p_english IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION lookup_while (p_english IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2);
END vocab2;
/

CREATE OR REPLACE PACKAGE BODY vocab2
-- Linear search
IS 
   TYPE word_list IS TABLE OF translations%ROWTYPE
      INDEX BY BINARY_INTEGER /* can't use pls_integer pre-9.2 */;

   g_english_french   word_list;

   CURSOR trans_cur
   IS
      SELECT english, french
        FROM translations;

   FUNCTION lookup_while (p_english IN VARCHAR2)
      RETURN VARCHAR2
   IS 
      match_found   BOOLEAN                    := FALSE ;
      indx          PLS_INTEGER                := g_english_french.FIRST;
      last_row      PLS_INTEGER                := g_english_french.LAST;
      retval        translations.french%TYPE;
   BEGIN
      WHILE NOT match_found AND indx <= last_row
      LOOP
         IF g_english_french (indx).english = p_english
         THEN
            match_found := TRUE ;
            retval := g_english_french (indx).french;
         END IF;

         indx := indx + 1;
      END LOOP;

      RETURN retval;
   END lookup_while;

   FUNCTION lookup_for (p_english IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      FOR j IN 1 .. g_english_french.LAST ()
      LOOP
         IF g_english_french (j).english = p_english
         THEN
            RETURN g_english_french (j).french;
         END IF;
      END LOOP;
   END lookup_for;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2)
   IS 
      idx   BINARY_INTEGER;
   BEGIN
      idx := g_english_french.LAST () + 1;
      g_english_french (idx).english := p_english;
      g_english_french (idx).french := p_french;

      INSERT INTO translations
                  (english, french)
           VALUES (p_english, p_french);
   END new_pair;

BEGIN                                               /* package initialization */
   DECLARE
      indx   PLS_INTEGER := 0;
   BEGIN
      FOR rec IN trans_cur
      LOOP
         indx := indx + 1;
         g_english_french (indx).english := rec.english;
         g_english_french (indx).french := rec.french;
      END LOOP;
   END;
END vocab2;
/
