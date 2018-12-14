CREATE OR REPLACE FUNCTION fibonacci (n PLS_INTEGER)
   RETURN PLS_INTEGER
   AUTHID DEFINER
IS
   fib_1   PLS_INTEGER := 0;
   fib_2   PLS_INTEGER := 1;
BEGIN
   IF n = 1
   THEN
      RETURN fib_1;
   ELSIF n = 2
   THEN
      RETURN fib_2;
   ELSE
      RETURN fibonacci (n - 2) + fibonacci (n - 1);
   END IF;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (fibonacci (10));
END;
/

CREATE OR REPLACE FUNCTION fibonacci (series_length IN NUMBER)
   RETURN INTEGER
AS
   n0   NUMBER := 0;
   n1   NUMBER := 1;
   n2   NUMBER := 0;
BEGIN
   FOR i IN n0 .. series_length - 3
   LOOP
      n2 := n0 + n1;
      n0 := n1;
      n1 := n2;
   END LOOP;

   RETURN n2;
END fibonacci;
/

BEGIN
   DBMS_OUTPUT.put_line (fibonacci (10));
END;
/

CREATE OR REPLACE FUNCTION fibonacci (n POSITIVE)
   RETURN INTEGER
IS
   pos1   INTEGER := 1;
   pos2   INTEGER := 0;
   cum    INTEGER;
BEGIN
   IF (n = 1) OR (n = 2)
   THEN
      RETURN 1;
   ELSE
      cum := pos1 + pos2;

      FOR i IN 3 .. n
      LOOP
         pos2 := pos1;
         pos1 := cum;
         cum := pos1 + pos2;
      END LOOP;

      RETURN cum;
   END IF;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (fibonacci (10));
END;
/

CREATE OR REPLACE FUNCTION fibonacci (n_in in integer)
   RETURN INTEGER
IS
   l_return   INTEGER;
BEGIN
   SELECT MAX (fib_value)
     INTO l_return
     FROM (    SELECT ROUND (
                           (  POWER ( (1 + SQRT (5)) / 2, LEVEL - 1)
                            - POWER ( (1 - SQRT (5)) / 2, LEVEL - 1))
                         / SQRT (5)) fib_value
                 FROM DUAL
           CONNECT BY LEVEL <= n_in);

   RETURN l_return;
END;
/

BEGIN
   DBMS_OUTPUT.put_line (fibonacci (10));
END;
/