CREATE OR REPLACE FUNCTION upper_first_letter (string_in IN VARCHAR2)
   RETURN VARCHAR2
IS
   l_return   VARCHAR2 (32767)
                 := UPPER (SUBSTR (string_in, 1, 1)) || SUBSTR (string_in, 2);
   l_loc      PLS_INTEGER := 0;
BEGIN
   LOOP
      l_loc := INSTR (l_return, ' ', l_loc + 1);
      EXIT WHEN l_loc = 0;
      l_return :=
            SUBSTR (l_return, 1, l_loc)
         || UPPER (SUBSTR (l_return, l_loc + 1, 1))
         || SUBSTR (string_in, l_loc + 2);
      l_loc := l_loc + 1;
   END LOOP;

   RETURN l_return;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (upper_first_letter ('this needs initcap'));
END;
/
