CREATE OR REPLACE TYPE qu_integers_aat IS TABLE OF INTEGER;
/

CREATE OR REPLACE FUNCTION random_integers (
   count_in       IN   PLS_INTEGER DEFAULT 100
 , min_value_in   IN   PLS_INTEGER DEFAULT 1
 , max_value_in   IN   PLS_INTEGER DEFAULT 1000
)
   RETURN qu_integers_aat
IS
   l_value       PLS_INTEGER;
   l_values      qu_integers_aat                     := qu_integers_aat ();
   l_used        qu_config.maxvarchar2_by_string_aat;
   l_hit_count   PLS_INTEGER                         DEFAULT 0;
BEGIN
   

   WHILE (l_values.COUNT < count_in)
   LOOP
      l_value := DBMS_RANDOM.VALUE (min_value_in, max_value_in);
      DBMS_OUTPUT.put_line ('value = ' || l_value);

      IF l_used.EXISTS (l_value)
      THEN
         l_hit_count := l_hit_count + 1;

         IF l_hit_count >= count_in * 5
         THEN
            raise_application_error
                           (-20000
                          ,    'Random generation error: Unable to generate '
                            || count_in
                            || ' distinct integers with min and max values '
                            || min_value_in
                            || ' and '
                            || max_value_in
                            || '.'
                           );
         END IF;
      ELSE
      l_values.EXTEND;
         l_values (l_values.last) := l_value;
         l_used (l_value) := l_value;
      END IF;
   END LOOP;

   RETURN l_values;
END random_integers;
/

DECLARE
   l   qu_integers_aat;
BEGIN
   l := random_integers (20);
   DBMS_OUTPUT.put_line (l.COUNT);
   DBMS_OUTPUT.put_line (l (1));
END;
/

SELECT *
  FROM TABLE (random_integers (20))
/