/* Formatted by PL/Formatter v3.1.2.1 on 2000/08/01 11:45 */

CREATE OR REPLACE PROCEDURE ibtabtest (
   num IN INTEGER
)
IS
         TYPE tab_t IS TABLE OF VARCHAR2 (100)
            INDEX BY BINARY_INTEGER;

         tab tab_t;
BEGIN
   sf_timer.start_timer;

   FOR i IN 1 .. num
   LOOP
       tab (i * 100) := 'steven';
       tab (i * 1000) := 'steven';
       tab.delete (i * 1000, i * 1000);
   END LOOP;

   sf_timer.show_elapsed_time ('Delete tab');

END;
/
sho err

exec ibtabtest (100);
exec ibtabtest (1000);
exec ibtabtest (10000);
REM exec ibtabtest (100000);

drop procedure ibtabtest;

