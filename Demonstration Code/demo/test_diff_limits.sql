DECLARE
   PROCEDURE fetch_all_rows (limit_in IN PLS_INTEGER)
   IS
      CURSOR source_cur
      IS
         SELECT *
           FROM all_source;

      TYPE source_aat IS TABLE OF source_cur%ROWTYPE
         INDEX BY PLS_INTEGER;

      l_source   source_aat;
      l_start    PLS_INTEGER;
      l_end      PLS_INTEGER;
   BEGIN
      DBMS_SESSION.free_unused_user_memory;
      show_pga_memory (limit_in || ' - BEFORE');
      l_start := DBMS_UTILITY.get_cpu_time;

      OPEN source_cur;

      LOOP
         FETCH source_cur
         BULK COLLECT INTO l_source LIMIT limit_in;

         EXIT WHEN l_source.COUNT = 0;
      END LOOP;

      CLOSE source_cur;

      l_end := DBMS_UTILITY.get_cpu_time;
      DBMS_OUTPUT.put_line (   'Elapsed CPU time for limit of '
                            || limit_in
                            || ' = '
                            || TO_CHAR (l_end - l_start)
                           );
      show_pga_memory (limit_in || ' - AFTER');
   END fetch_all_rows;
BEGIN
   fetch_all_rows (1);
   fetch_all_rows (5);
   fetch_all_rows (25);
   fetch_all_rows (50);
   fetch_all_rows (75);
   fetch_all_rows (100);
   fetch_all_rows (1000);
   fetch_all_rows (10000);
   fetch_all_rows (100000);
END;
/

/* Typical results on my Dell Core Duo with 4 gig of memory and Oracle 11.1 

Elapsed CPU time for limit of 1 = 1772
1 - AFTER - PGA memory used in session = 2253776

Elapsed CPU time for limit of 5 = 763
5 - AFTER - PGA memory used in session = 4482000

Elapsed CPU time for limit of 25 = 559
25 - AFTER - PGA memory used in session = 4547536

Elapsed CPU time for limit of 50 = 509
50 - AFTER - PGA memory used in session = 4678608

Elapsed CPU time for limit of 75 = 544
75 - AFTER - PGA memory used in session = 4678608

Elapsed CPU time for limit of 100 = 489
100 - AFTER - PGA memory used in session = 4744144

Elapsed CPU time for limit of 1000 = 489
1000 - AFTER - PGA memory used in session = 5399504

Elapsed CPU time for limit of 10000 = 463
10000 - AFTER - PGA memory used in session = 10904528

Elapsed CPU time for limit of 100000 = 528
100000 - AFTER - PGA memory used in session = 46818256

*/