CREATE OR REPLACE FUNCTION revstr (
   string_in IN VARCHAR2
)
   RETURN VARCHAR2
IS
   l_position   PLS_INTEGER := 1;
   l_length     PLS_INTEGER := NVL (LENGTH (string_in), 0);
   l_return     VARCHAR2 (32767);
BEGIN
   WHILE (l_position <= l_length)
   LOOP
      l_return := SUBSTR (string_in, l_position, 1) || l_return;
      l_position := l_position + 1;
   END LOOP;

   RETURN l_return;
END revstr;
/
