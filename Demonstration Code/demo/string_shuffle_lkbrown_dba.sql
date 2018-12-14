/*

Found in http://forums.devshed.com/oracle-development-96/randomize-a-string-422278.html

by LKBrwn_DBA

Doesn't seem to work very well. Always returns same order of "shuffled" string.

*/

CREATE OR REPLACE FUNCTION rnd_string (txt VARCHAR2)
   RETURN VARCHAR2
IS
   TYPE in_typ IS TABLE OF CHAR (1)
                     INDEX BY BINARY_INTEGER;

   in_str    in_typ;
   out_str   VARCHAR2 (1000) := '';
   i         PLS_INTEGER;
   j         PLS_INTEGER;
   k         PLS_INTEGER;
   l         PLS_INTEGER;
   r         PLS_INTEGER;
BEGIN
   l := LENGTH (txt);
   i := 1;

   FOR k IN 1 .. l
   LOOP
      in_str (k) := SUBSTR (txt, k, 1);
   END LOOP;

   r := MOD (TO_CHAR (SYSTIMESTAMP, 'SSSSS'), 32767);
   DBMS_RANDOM.initialize (r + 1);

   FOR k IN 1 .. l
   LOOP
      IF in_str (k) = ' '
      THEN
         r := k;
      ELSE
         r := MOD (DBMS_RANDOM.random, l);
         j := -1 * SIGN (r);
         r := ABS (r) + 1;

         IF j = 0
         THEN
            j := -1;
         END IF;

         WHILE (in_str (r) IN (CHR (0), ' '))
         LOOP
            r := r + j;

            IF r > l
            THEN
               r := 1;
            END IF;

            IF r < 1
            THEN
               r := l;
            END IF;
         END LOOP;
      END IF;

      out_str := out_str || in_str (r);
      in_str (r) := CHR (0);
   END LOOP;

   RETURN INITCAP (RPAD (LTRIM (out_str), l));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (rnd_string ('abcdef'));
   DBMS_OUTPUT.put_line (rnd_string ('abcdef'));
   DBMS_OUTPUT.put_line (rnd_string ('abcdef'));
   DBMS_OUTPUT.put_line (rnd_string ('abcdef'));
   DBMS_OUTPUT.put_line (rnd_string ('abcdef'));
END;
/