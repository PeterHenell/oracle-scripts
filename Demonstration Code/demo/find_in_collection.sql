DECLARE
   TYPE number_ntt IS TABLE OF NUMBER;

   in_list   number_ntt := number_ntt ();
   l_cnt     PLS_INTEGER;
   l_hits    PLS_INTEGER := 0;
BEGIN
   /* Add 100 elements to the collection "IN-list"... */
   in_list.EXTEND (100);

   FOR i IN 1 .. 100
   LOOP
      in_list (i) := i;
   END LOOP;

   /* MEMBER OF */
   FOR i IN 1 .. 10000
   LOOP
      IF i MEMBER OF in_list
      THEN
         l_hits := l_hits + 1;
      END IF;
   END LOOP;

   /* Collection loop... */
   l_hits := 0;

   FOR i IN 1 .. 10000
   LOOP
      FOR ii IN 1 .. in_list.COUNT
      LOOP
         IF i = in_list (ii)
         THEN
            l_hits := l_hits + 1;
            EXIT;
         END IF;
      END LOOP;
   END LOOP;

   /* Table operator */
   FOR i IN 1 .. 10000
   LOOP
      SELECT COUNT (*)
        INTO l_cnt
        FROM TABLE (in_list)
       WHERE COLUMN_VALUE = i;

      IF l_cnt > 0
      THEN
         l_hits := l_hits + 1;
      END IF;
   END LOOP;
END;
/