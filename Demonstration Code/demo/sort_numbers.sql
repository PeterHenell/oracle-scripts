/* Need to sort data supplied to a procedure */

CREATE OR REPLACE PROCEDURE sort_numbers (
   numbers_io IN OUT NOCOPY DBMS_SQL.number_table)
IS
BEGIN
   NULL;
END;
/

create or replace proceedure show_sorted
is
   l_numbers   DBMS_SQL.number_table;
BEGIN
   l_numbers (1) := 100;
   l_numbers (11) := 1000;
   l_numbers (1456) := 1;
   l_numbers (10101) := 10;
   l_numbers (-15) := 10000;
   
   sort_numbers (l_numbers);

   FOR indx IN 1 .. l_numbers.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_numbers (indx));
   END LOOP;
END;
/

