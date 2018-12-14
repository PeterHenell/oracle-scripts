CREATE OR REPLACE PROCEDURE pl (str IN VARCHAR2)
IS
   c_len     constant PLS_INTEGER      := 255;
   l_len pls_integer := c_len;
   l_len2    PLS_INTEGER;
   l_chr10   PLS_INTEGER;
   l_str     VARCHAR2 (32767);
BEGIN
   IF LENGTH (str) > c_len
   THEN
      l_chr10 := INSTR (str, CHR (10));

      IF l_chr10 > 0 AND l_len >= l_chr10
      THEN
         l_len := l_chr10 - 1;
         l_len2 := l_chr10 + 1;
      ELSE
         l_len2 := l_len + 1;
      END IF;

      l_str := SUBSTR (str, 1, l_len);
      DBMS_OUTPUT.put_line (l_str);
      pl (SUBSTR (str, l_len2));
   ELSE
      l_str := str;
      DBMS_OUTPUT.put_line (str);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.ENABLE (1000000);
      DBMS_OUTPUT.put_line (l_str);
END pl;
/
