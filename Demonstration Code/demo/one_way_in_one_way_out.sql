/* For loop with two ways out.

   Never use EXIT WHEN inside a FOR loop.
   
*/

DECLARE
   l_sales         NUMBER;
   l_total_sales   NUMBER;

   PROCEDURE calc_sales (month_num_in IN INTEGER, sales_out OUT NUMBER)
   IS
   BEGIN
      sales_out := month_num_in * 1000;
   END calc_sales;
BEGIN
   FOR month_num IN 1 .. 12
   LOOP
      calc_sales (month_num, l_sales);
      l_total_sales := l_total_sales + l_sales;
      EXIT WHEN l_total_sales > 1000000;
   END LOOP;

   DBMS_OUTPUT.put_line ('No errors, but....');
END;
/

/* WHILE loop with two ways out.

   Never use EXIT WHEN inside a WHILE loop.
   
*/

DECLARE
   month_num       INTEGER := 1;
   l_sales         NUMBER;
   l_total_sales   NUMBER;

   PROCEDURE calc_sales (month_num_in IN INTEGER, sales_out OUT NUMBER)
   IS
   BEGIN
      sales_out := month_num_in * 1000;
   END calc_sales;
BEGIN
   WHILE (month_num <= 12)
   LOOP
      calc_sales (month_num, l_sales);
      l_total_sales := l_total_sales + l_sales;
      EXIT WHEN l_total_sales > 1000000;
      month_num := month_num + 1;
   END LOOP;

   DBMS_OUTPUT.put_line ('No errors, but....');
END;
/

/* Don't use GOTO to escape a loop.
   
*/

DECLARE
   month_num       INTEGER := 1;
   l_sales         NUMBER;
   l_total_sales   NUMBER;

   PROCEDURE calc_sales (month_num_in IN INTEGER, sales_out OUT NUMBER)
   IS
   BEGIN
      sales_out := month_num_in * 1000;
   END calc_sales;
BEGIN
   WHILE (month_num <= 12)
   LOOP
      calc_sales (month_num, l_sales);
      l_total_sales := l_total_sales + l_sales;

      IF l_total_sales > 1000000
      THEN
         GOTO all_done;
      END IF;

      month_num := month_num + 1;
   END LOOP;

  <<all_done>>
   DBMS_OUTPUT.put_line ('No errors, but....');
END;
/