CREATE OR REPLACE PROCEDURE plsb (str IN VARCHAR2, val IN BOOLEAN, len in pls_integer default 80)
IS
   PROCEDURE pl (
      str         IN   VARCHAR2,
      len         IN   INTEGER := 80
   )
   IS
      v_len     PLS_INTEGER     := LEAST (len, 255);
      v_len2    PLS_INTEGER;
      v_chr10   PLS_INTEGER;
      v_str     VARCHAR2 (2000);
   BEGIN
      IF LENGTH (str) > v_len
      THEN
         v_chr10 := INSTR (str, CHR (10));

         IF v_chr10 > 0 AND v_len >= v_chr10
         THEN
            v_len := v_chr10 - 1;
            v_len2 := v_chr10 + 1;
         ELSE
            v_len2 := v_len + 1;
         END IF;

         v_str := SUBSTR (str, 1, v_len);
         DBMS_OUTPUT.put_line (v_str);
         pl (SUBSTR (str, v_len2), len);
      ELSE
         DBMS_OUTPUT.put_line (str);
      END IF;
   END pl;
BEGIN
   IF val
   THEN
      pl (str || ' - TRUE', len);
   ELSIF NOT val
   THEN
      pl (str || ' - FALSE', len);
   ELSE
      pl (str || ' - NULL', len);
   END IF;
END plsb;
/