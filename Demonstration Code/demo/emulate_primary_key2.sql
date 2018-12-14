/* 
Demonstrate benefits of non-sequential indexing:

Compare performance of looking up data in table each time
vs
Cache data in a collection using the primary key as the index.

Step 2. Run script using sf_timer to calculate elapsed times.

*/

DECLARE
   emprec   employees%ROWTYPE;
BEGIN
   sf_timer.start_timer;

   FOR i IN 1 .. 100000
   LOOP
      emprec := emplu2.onerow (138);
   END LOOP;

   sf_timer.show_elapsed_time ('Associative array cache');

   sf_timer.start_timer;

   FOR i IN 1 .. 100000
   LOOP
      emprec := emplu1.onerow (138);
   END LOOP;

   sf_timer.show_elapsed_time ('Database table lookup');

   /* Now let's load up the cache with 10000000 rows of data
      and see how long it takes to find each element. */

   FOR indx IN 1 .. 1000000
   LOOP
      emplu2.employee_cache (indx).employee_id := 1;
      emplu2.employee_cache (indx).last_name := 'Name ' || indx;
   END LOOP;

   sf_timer.start_timer;

   FOR i IN 1 .. 1000000
   LOOP
      emprec.last_name := emplu2.employee_cache (i).last_name;
   END LOOP;

   sf_timer.show_elapsed_time ('1000000 AA lookups');

   /* Release the memory for this big collection */
   emplu2.employee_cache.delete;
END;
/

/* Results on 11.2

"Associative array lookup" completed in: .14
"Database table lookup" completed in: 4.11
"1000000 AA lookups" completed in: .14

*/