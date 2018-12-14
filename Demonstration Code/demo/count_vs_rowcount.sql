DECLARE
   CURSOR source_cur
   IS
      SELECT *
        FROM all_source
       WHERE ROWNUM < 100000;

   TYPE source_aat IS TABLE OF all_source%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_source   source_aat;
   l_counter pls_integer := 1;
BEGIN
   sf_timer.start_timer;

   FOR rec IN source_cur
   LOOP
      l_source (l_source.COUNT + 1) := rec;
   END LOOP;

   sf_timer.show_elapsed_time ('COUNT');
   --
   sf_timer.start_timer;

   FOR rec IN source_cur
   LOOP
      l_source (source_cur%ROWCOUNT) := rec;
   END LOOP;

   sf_timer.show_elapsed_time ('ROWCOUNT');
   --
   sf_timer.start_timer;

   FOR rec IN source_cur
   LOOP
      l_source (l_counter) := rec;
      l_counter := l_counter + 1;
   END LOOP;

   sf_timer.show_elapsed_time ('VARIABLE COUNTER');   
/*

10g

COUNT Elapsed: 2.29 seconds.
ROWCOUNT Elapsed: .86 seconds.

11g

COUNT - Elapsed CPU : 1.05 seconds.
ROWCOUNT - Elapsed CPU : .93 seconds.
VARIABLE COUNTER - Elapsed CPU : .92 seconds.

*/
   
END;
/