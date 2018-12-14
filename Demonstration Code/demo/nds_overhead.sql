/*

What sort of overhead can you expect from NDS?

Very little, as you can see from the results of running this script:

Embedded SQL - Elapsed CPU : 130.74 seconds.
NDS - Elapsed CPU : 134.05 seconds.

4 seconds over 100000 separate updates of 107 rows.

*/ 
BEGIN
   sf_timer.start_timer;

   FOR i IN 1 .. 100000
   LOOP
      UPDATE employees
         SET last_name = last_name;
   END LOOP;

   sf_timer.show_elapsed_time ('Embedded SQL');
   ROLLBACK;
   --
   sf_timer.start_timer;

   FOR i IN 1 .. 100000
   LOOP
      EXECUTE IMMEDIATE 'update employees set last_name = last_name';
   END LOOP;

   sf_timer.show_elapsed_time ('NDS');
   ROLLBACK;
END;
/