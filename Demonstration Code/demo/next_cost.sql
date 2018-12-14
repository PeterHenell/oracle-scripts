DECLARE
   TYPE array_t IS TABLE OF PLS_INTEGER
      INDEX BY PLS_INTEGER;

   ARRAY          array_t;
   --
   l_start_time   PLS_INTEGER;
   l_end_time     PLS_INTEGER;
   --
   l_row          PLS_INTEGER;
BEGIN
   -- Populate the collection.
   FOR n IN 1 .. 10000000
   LOOP
      ARRAY (n) := n;
   END LOOP;

   -- Cache the starting time.
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR n IN 1 .. ARRAY.COUNT
   LOOP
      ARRAY (n) := n;
   END LOOP;

   -- Subtract end time from start time.
   DBMS_OUTPUT.put_line (   'FOR loop elapsed CPU time: '
                         || TO_CHAR (DBMS_UTILITY.get_cpu_time - l_start_time)
                        );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;
   l_row := ARRAY.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      ARRAY (l_row) := l_row;
      l_row := ARRAY.NEXT (l_row);
   END LOOP;

   DBMS_OUTPUT.put_line (   'WHILE loop elapsed CPU time: '
                         || TO_CHAR (DBMS_UTILITY.get_cpu_time - l_start_time)
                        );
/*
1000000 rows
COUNT Elapsed: 1.22 seconds.
FIRST-NEXT Elapsed: 3.21 seconds.
*/
END;
/
