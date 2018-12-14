DECLARE
   SUBTYPE maxvarchar2_t IS VARCHAR2 (32767);

   TYPE by_string IS TABLE OF BOOLEAN
      INDEX BY maxvarchar2_t;

   TYPE by_integer IS TABLE OF maxvarchar2_t
      INDEX BY PLS_INTEGER;

   l_by_string    by_string;
   l_by_integer   by_integer;
   l_string       maxvarchar2_t;
   l_boolean boolean;
BEGIN
   FOR indx IN 1 .. 100000
   LOOP
      l_by_string (TO_CHAR (indx)) := TRUE;
      l_by_integer (l_by_integer.COUNT + 1) := TO_CHAR (indx);
   END LOOP;

   sf_timer.start_timer;

   FOR indx IN 1 .. 10000
   LOOP
      l_boolean := l_by_string (TO_CHAR (indx));
   END LOOP;

   sf_timer.show_elapsed_time ('Indexed by string');
   --
   sf_timer.start_timer;

   FOR indx IN 1 .. 10000
   LOOP
      DECLARE
         c_count   CONSTANT PLS_INTEGER := l_by_integer.COUNT;
         l_index            PLS_INTEGER := l_by_integer.FIRST;
      BEGIN
         WHILE (l_index <= c_count)
         LOOP
            IF TO_CHAR (indx) = l_by_integer (TO_CHAR (l_index))
            THEN
               l_string := l_by_integer (TO_CHAR (l_index));
               EXIT;
            END IF;

            l_index := l_index + 1;
         END LOOP;
      END;
   END LOOP;

   sf_timer.show_elapsed_time ('Indexed by integer');
END;
/

/*
Indexed by string - Elapsed CPU : 0 seconds.
Indexed by integer - Elapsed CPU : 21.36 seconds.
*/