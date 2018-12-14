CREATE OR REPLACE PACKAGE vocab3
IS 
   FUNCTION lookup (p_english IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2);
END vocab3;
/

CREATE OR REPLACE PACKAGE BODY vocab3
-- Use of hash algorithm to build index
IS 
   HASH                   BINARY_INTEGER;
   g_hash_base   CONSTANT NUMBER := 1       /* care must be given as to... */;
   g_hash_size   CONSTANT NUMBER := 1000000 /* ...the choice of these values */;

   TYPE word_list IS TABLE OF translations.french%TYPE
      INDEX BY BINARY_INTEGER;

   g_english_french       word_list;

   FUNCTION lookup (p_english IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      HASH := DBMS_UTILITY.get_hash_value (
                 p_english,
                 g_hash_base,
                 g_hash_size
              );
      RETURN g_english_french (HASH);
   END lookup;

   PROCEDURE new_pair (p_english IN VARCHAR2, p_french IN VARCHAR2)
   IS
   BEGIN
      HASH := DBMS_UTILITY.get_hash_value (
                 p_english,
                 g_hash_base,
                 g_hash_size
              );
      g_english_french (HASH) := p_french;

      INSERT INTO translations
                  (english, french)
           VALUES (p_english, p_french);
   END new_pair;

BEGIN                                               /* package initialization */
   BEGIN
      FOR rec IN (SELECT english, french
                  FROM translations)
      LOOP
         HASH := DBMS_UTILITY.get_hash_value (
                    rec.english,
                    g_hash_base,
                    g_hash_size
                 );
         g_english_french (HASH) := rec.french;
      END LOOP;
   END;
END vocab3;
/
