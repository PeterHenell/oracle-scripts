CREATE OR REPLACE PROCEDURE show_birthdays (second_row IN INTEGER)
IS
   TYPE dates_tt IS TABLE OF DATE
                       INDEX BY PLS_INTEGER;

   birthdays   dates_tt;
   l_date      DATE;
   l_row       PLS_INTEGER;
BEGIN
   birthdays (1) := '20-mar-72';
   birthdays (second_row) := '01-oct-86';
   DBMS_OUTPUT.put_line ('Timings with second row = ' || second_row);

   BEGIN
      FOR rowind IN birthdays.FIRST .. birthdays.LAST
      LOOP
         l_date := birthdays (rowind);
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line ('Tried to look at undefined element!');
   END;

   sf_timer.start_timer;

   IF birthdays.COUNT > 0
   THEN
      FOR rowind IN birthdays.FIRST .. birthdays.LAST
      LOOP
         IF birthdays.EXISTS (rowind)
         THEN
            l_date := birthdays (rowind);
         END IF;
      END LOOP;
   END IF;

   sf_timer.show_elapsed_time ('Check EXISTS each time');
   --
   sf_timer.start_timer;

   FOR rowind IN NVL (birthdays.FIRST, 0) .. NVL (birthdays.LAST, -1)
   LOOP
      BEGIN
         l_date := birthdays (rowind);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END LOOP;

   sf_timer.show_elapsed_time ('Trap NDF each time');
   --
   sf_timer.start_timer;
   l_row := birthdays.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      l_date := birthdays (l_row);
      l_row := birthdays.NEXT (l_row);
   END LOOP;

   sf_timer.show_elapsed_time ('Use FIRST and NEXT');
END;
/

BEGIN
   show_birthdays (2);
   show_birthdays (1000000);
END;
/

/*
Timings with second row = 2
Check EXISTS each time - Elapsed CPU : 0 seconds.
Trap NDF each time - Elapsed CPU : 0 seconds.
Use FIRST and NEXT - Elapsed CPU : 0 seconds.

Timings with second row = 1000000
Tried to look at undefined element!
Check EXISTS each time - Elapsed CPU : .16 seconds.
Trap NDF each time - Elapsed CPU : 1.72 seconds.
Use FIRST and NEXT - Elapsed CPU : 0 seconds.
*/