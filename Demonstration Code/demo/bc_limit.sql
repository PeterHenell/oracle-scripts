DROP TABLE bc_limit_table
/
CREATE TABLE bc_limit_table
 (
   NAME VARCHAR2(100),
   age NUMBER
)
/

DECLARE
   TYPE bc_tt IS TABLE OF bc_limit_table%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_bc   bc_tt;
BEGIN
   FOR indx IN 1 .. 1000000
   LOOP
      l_bc (indx).NAME := 'Simply Amazing ' || indx;
      l_bc (indx).age := indx;
   END LOOP;

   FORALL indx IN 1 .. 1000000
      INSERT INTO bc_limit_table
           VALUES l_bc (indx);
   COMMIT;
END;
/

DECLARE
   counter   PLS_INTEGER := 1;

   CURSOR bc_cur
   IS
      SELECT *
        FROM bc_limit_table;

   TYPE bc_tt IS TABLE OF bc_limit_table%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_bc      bc_tt;

   PROCEDURE try_limit (limit_in IN PLS_INTEGER)
   IS
   BEGIN
      DBMS_SESSION.free_unused_user_memory;
      my_session.MEMORY;
      sf_timer.start_timer;

      FOR i IN 1 .. counter
      LOOP
         OPEN bc_cur;

         LOOP
            FETCH bc_cur
            BULK COLLECT INTO l_bc LIMIT limit_in;

            EXIT WHEN l_bc.COUNT = 0;
         END LOOP;

         CLOSE bc_cur;
      END LOOP;

      sf_timer.show_elapsed_time ('Limit = ' || limit_in);
      my_session.MEMORY;
   END try_limit;
BEGIN
   PLVtmr.set_factor (counter);
   try_limit (5);
   try_limit (100);
   try_limit (200);
   try_limit (500);
   try_limit (1000);
   try_limit (10000);
END;
/