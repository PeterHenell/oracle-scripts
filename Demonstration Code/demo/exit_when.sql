DECLARE
   l_index   PLS_INTEGER := 1;
BEGIN
   LOOP
      DBMS_OUTPUT.put_line (l_index);
      EXIT WHEN l_index = 3;
      l_index := l_index + 1;
   END LOOP my_loop;
END;
/

DECLARE
   l_index   PLS_INTEGER := 1;
BEGIN
   LOOP
      DBMS_OUTPUT.put_line (l_index);

      IF l_index = 3
      THEN
         EXIT;
      END IF;

      l_index := l_index + 1;
   END LOOP my_loop;
END;
/

DECLARE
   l_index   PLS_INTEGER := 1;
BEGIN
   LOOP
      DBMS_OUTPUT.put_line (l_index);

      IF l_index = 3
      THEN
         RAISE PROGRAM_ERROR;
      END IF;

      l_index := l_index + 1;
   END LOOP my_loop;
EXCEPTION
   WHEN PROGRAM_ERROR
   THEN
      NULL;
END;
/

DECLARE
   l_index   PLS_INTEGER := 1;
BEGIN
   LOOP
      DBMS_OUTPUT.put_line (l_index);
      WHEN l_index = 3 THEN EXIT;
      l_index := l_index + 1;
   END LOOP my_loop;
END;
/