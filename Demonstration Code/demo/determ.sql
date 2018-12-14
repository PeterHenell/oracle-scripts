CREATE OR REPLACE FUNCTION betwnstr (
   string_in   IN   VARCHAR2
 , start_in    IN   INTEGER
 , end_in      IN   INTEGER
)
   RETURN VARCHAR2
IS
   l   PLS_INTEGER;
BEGIN
   FOR indx IN 1 .. 10000000
   LOOP
      l := indx;
   END LOOP;

   RETURN 'abc';
END;
/

BEGIN
   sf_timer.start_timer;

   FOR rec IN (SELECT betwnstr ('abc', 1, 5)
                 FROM emp)
   LOOP
      NULL;
   END LOOP;

   sf_timer.show_elapsed_time ('non-determ function');
END;
/

CREATE OR REPLACE FUNCTION betwnstr (
   string_in   IN   VARCHAR2
 , start_in    IN   INTEGER
 , end_in      IN   INTEGER
)
   RETURN VARCHAR2 DETERMINISTIC
IS
   l   PLS_INTEGER;
BEGIN
   FOR indx IN 1 .. 10000000
   LOOP
      l := indx;
   END LOOP;

   RETURN 'abc';
END;
/

BEGIN
   sf_timer.start_timer;

   FOR rec IN (SELECT betwnstr ('abc', 1, 5)
                 FROM emp)
   LOOP
      NULL;
   END LOOP;

   sf_timer.show_elapsed_time ('determ function');
END;
/