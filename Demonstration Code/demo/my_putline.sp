CREATE OR REPLACE PROCEDURE my_putline (
   str         IN   VARCHAR2,
   len         IN   INTEGER := 80,
   expand_in   IN   BOOLEAN := TRUE
)
IS 
   v_len     PLS_INTEGER := LEAST (len, 255);
   v_len2    PLS_INTEGER;
   v_chr10   PLS_INTEGER;
   v_str VARCHAR2(2000);
BEGIN
   IF LENGTH (str) > v_len
   THEN
      -- Preserve existing line breaks.
      v_chr10 := INSTR (str, CHR (10));

      IF v_chr10 > 0 AND v_len >= v_chr10
      THEN
         v_len := v_chr10 - 1;
         v_len2 := v_chr10 + 1;
      ELSE
         v_len := v_len - 1;
         v_len2 := v_len;
      END IF;

	  v_str := SUBSTR (str, 1, v_len);
      DBMS_OUTPUT.put_line (v_str);
      my_putline (SUBSTR (str, v_len2), len, expand_in);
   ELSE
      DBMS_OUTPUT.put_line (str);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      IF expand_in
      THEN
         DBMS_OUTPUT.ENABLE (1000000);
         DBMS_OUTPUT.put_line (v_str);
      ELSE
         RAISE;
      END IF;
END my_putline;
/
