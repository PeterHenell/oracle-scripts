DECLARE
   c_iterations   PLS_INTEGER := 7500;
   c_concats   PLS_INTEGER := 1500;

   TYPE vc32767 IS TABLE OF VARCHAR2 (32767)
      INDEX BY PLS_INTEGER;

   l_vc32767      vc32767;

   TYPE vc5000 IS TABLE OF VARCHAR2 (5000)
      INDEX BY PLS_INTEGER;

   l_vc5000       vc5000;

   TYPE vc1900 IS TABLE OF VARCHAR2 (1900)
      INDEX BY PLS_INTEGER;

   l_vc1900       vc1900;
BEGIN
   sf_timer.start_timer;

   FOR i IN 1 .. c_iterations
   LOOP
      l_vc32767 (i) := 'a';

      FOR j IN 1 .. c_concats
      LOOP
         l_vc32767 (i) := l_vc32767 (i) || 'a';
      END LOOP;
   END LOOP;

   sf_timer.show_elapsed_time ('32767');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. c_iterations
   LOOP
      l_vc5000 (i) := 'a';

      FOR j IN 1 .. c_concats
      LOOP
         l_vc5000 (i) := l_vc5000 (i) || 'a';
      END LOOP;
   END LOOP;

   sf_timer.show_elapsed_time ('5000');
   --
   sf_timer.start_timer;

   FOR i IN 1 .. c_iterations
   LOOP
      l_vc1900 (i) := 'a';

      FOR j IN 1 .. c_concats
      LOOP
         l_vc1900 (i) := l_vc1900 (i) || 'a';
      END LOOP;
   END LOOP;

   sf_timer.show_elapsed_time ('1900');
END;
/