DECLARE
   l_characters   VARCHAR2 (26) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
BEGIN
   FOR indx IN 1 .. 26
   LOOP
      DBMS_OUTPUT.put_line (   SUBSTR (l_characters, indx, 1)
                            || ' = '
                            || ASCII (SUBSTR (l_characters, indx, 1))
                           );
   END LOOP;
END display_ascii_codes;
/