CREATE OR REPLACE PROCEDURE test_cursor_performance (approach IN VARCHAR2)
IS
   CURSOR cur
   IS
      SELECT *
        FROM all_source
       WHERE ROWNUM < 100001;

   one_row     cur%ROWTYPE;

   TYPE t IS TABLE OF cur%ROWTYPE
                INDEX BY PLS_INTEGER;

   many_rows   t;
   
      last_timing   NUMBER := NULL;

   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
   END;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line('"' || message_in || '" completed in: '
                           || ROUND (
                                 MOD (
                                      DBMS_UTILITY.get_cpu_time
                                    - last_timing
                                    + POWER (2, 32)
                                  , POWER (2, 32)
                                 )
                                 / 100
                               , 2
                              ));
   END;
BEGIN
   start_timer;

   CASE approach
      WHEN 'implicit cursor for loop'
      THEN
         FOR j IN cur
         LOOP
            NULL;
         END LOOP;
      WHEN 'explicit open, fetch, close'
      THEN
         OPEN cur;

         LOOP
            
            FETCH cur
            INTO one_row;

            EXIT WHEN cur%NOTFOUND;
         END LOOP;

         CLOSE cur;
      WHEN 'bulk fetch'
      THEN
         OPEN cur;

         LOOP
            FETCH cur
            BULK COLLECT INTO many_rows
            LIMIT 100;

            EXIT WHEN many_rows.COUNT () = 0;
         END LOOP;

         CLOSE cur;
   END CASE;

   show_elapsed_time (approach);
END test_cursor_performance;
/

/* Try different approaches with optimization disabled. */
ALTER PROCEDURE test_cursor_performance COMPILE plsql_optimize_level=0
/

BEGIN
   DBMS_OUTPUT.put_line ('No optimization...');
   test_cursor_performance ('implicit cursor for loop');

   test_cursor_performance ('explicit open, fetch, close');

   test_cursor_performance ('bulk fetch');
END;
/

/* Try different approaches with default optimization. */
ALTER PROCEDURE test_cursor_performance COMPILE plsql_optimize_level=2
/

BEGIN
   DBMS_OUTPUT.put_line ('Default optimization...');

   test_cursor_performance ('implicit cursor for loop');

   test_cursor_performance ('explicit open, fetch, close');

   test_cursor_performance ('bulk fetch');
END;
/

/* Try different approaches with DEBUG enabled. */

ALTER PROCEDURE test_cursor_performance COMPILE DEBUG
/

BEGIN
   DBMS_OUTPUT.put_line ('DEBUG enabled...');

   test_cursor_performance ('implicit cursor for loop');

   test_cursor_performance ('explicit open, fetch, close');

   test_cursor_performance ('bulk fetch');
END;
/

/*

On 11.2

No optimization...
"implicit cursor for loop" completed in: 2.95
"explicit open, fetch, close" completed in: 2.75
"bulk fetch" completed in: 1.33

Default optimization...
"implicit cursor for loop" completed in: 1.36
"explicit open, fetch, close" completed in: 2.75
"bulk fetch" completed in: 1.44

DEBUG enabled...
"implicit cursor for loop" completed in: 2.74
"explicit open, fetch, close" completed in: 2.78
"bulk fetch" completed in: 1.31

*/