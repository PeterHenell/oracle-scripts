/* Need to sort data supplied to a procedure */

CREATE OR REPLACE PROCEDURE plch_sort_numbers (
   numbers_io IN OUT NOCOPY DBMS_SQL.number_table)
IS
BEGIN
   NULL;
END;
/

CREATE OR REPLACE PROCEDURE plch_show_sorted
IS
   l_numbers   DBMS_SQL.number_table;
BEGIN
   l_numbers (1) := 100;
   l_numbers (11) := 1000;
   l_numbers (1456) := 1;
   l_numbers (10101) := 10;
   l_numbers (-15) := 10000;

   plch_sort_numbers (l_numbers);

   FOR indx IN 1 .. l_numbers.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_numbers (indx));
   END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE plch_sort_numbers (
   numbers_io IN OUT NOCOPY DBMS_SQL.number_table)
IS
   l_index     PLS_INTEGER := numbers_io.FIRST;
   l_numbers   DBMS_SQL.number_table;
BEGIN
   WHILE (l_index IS NOT NULL)
   LOOP
      l_numbers (numbers_io (l_index)) := l_index;
      l_index := numbers_io.NEXT (l_index);
   END LOOP;

   numbers_io.delete;

   l_index := l_numbers.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      numbers_io (numbers_io.COUNT + 1) := l_index;
      l_index := l_numbers.NEXT (l_index);
   END LOOP;
END;
/

BEGIN
   plch_show_sorted;
END;
/

/* Test performance of sorting on large numbers of elements */

CREATE OR REPLACE PROCEDURE plch_sort_numbers (
   numbers_io IN OUT NOCOPY DBMS_SQL.number_table)
IS
   l_index     PLS_INTEGER := numbers_io.FIRST;
   l_numbers   DBMS_SQL.number_table;
BEGIN
   DBMS_OUTPUT.put_line ('Array Size = ' || numbers_io.COUNT);
   sf_timer.start_timer;

   WHILE (l_index IS NOT NULL)
   LOOP
      l_numbers (numbers_io (l_index)) := l_index;
      l_index := numbers_io.NEXT (l_index);
   END LOOP;

   numbers_io.delete;

   l_index := l_numbers.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      numbers_io (numbers_io.COUNT + 1) := l_index;
      l_index := l_numbers.NEXT (l_index);
   END LOOP;

   sf_timer.show_elapsed_time ('Sorted Size = ' || numbers_io.COUNT);
END;
/

CREATE OR REPLACE PROCEDURE plch_show_sorted (how_many_in IN PLS_INTEGER)
IS
   l_numbers   DBMS_SQL.number_table;
   l_index     PLS_INTEGER;
   l_counter   PLS_INTEGER := 0;
BEGIN
   /* Populate a collection with specified number of values. */
   
   WHILE (l_counter < how_many_in)
   LOOP
      l_index := DBMS_RANDOM.VALUE (1, how_many_in);

      IF l_numbers.EXISTS (l_index)
      THEN
         /* skip it */
         NULL;
      ELSE
         l_numbers (l_index) := l_index + DBMS_RANDOM.VALUE (1, how_many_in);
         l_counter := l_counter + 1;
      END IF;
   END LOOP;

   plch_sort_numbers (l_numbers);
END;
/

BEGIN
   plch_show_sorted (1000);
END;
/

BEGIN
   plch_show_sorted (100000);
END;
/

BEGIN
   plch_show_sorted (1000000);
END;
/

/* 11.2 

Array Size = 1000
"Sorted Size = 741" completed in: 0
Array Size = 100000
"Sorted Size = 73607" completed in: .07
Array Size = 1000000
"Sorted Size = 735278" completed in: .69

*/