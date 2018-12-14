DECLARE
   TYPE customers_list_t IS TABLE OF VARCHAR2 (30);

   l_customers   customers_list_t
                     := customers_list_t ('Customer 1', 'Customer 3');
BEGIN
   IF l_customers is NOT EMPTY (l_customers)
   THEN
      DBMS_OUTPUT.put_line ('We have customers!');
   END IF;
END;
/

DECLARE
   TYPE customers_list_t IS TABLE OF VARCHAR2 (30);

   l_customers   customers_list_t
                     := customers_list_t ('Customer 1', 'Customer 3');
BEGIN
   IF l_customers IS NOT EMPTY
   THEN
      DBMS_OUTPUT.put_line ('We have customers!');
   END IF;
END;
/

DECLARE
   TYPE customers_list_t IS TABLE OF VARCHAR2 (30);

   l_customers   customers_list_t
                     := customers_list_t ('Customer 1', 'Customer 3');
BEGIN
   IF l_customers.COUNT > 0
   THEN
      DBMS_OUTPUT.put_line ('We have customers!');
   END IF;
END;
/

DECLARE
   TYPE customers_list_t IS TABLE OF VARCHAR2 (30);

   l_customers   customers_list_t
                     := customers_list_t ('Customer 1', 'Customer 3');
BEGIN
   IF l_customers HAS ELEMENTS
   THEN
      DBMS_OUTPUT.put_line ('We have customers!');
   END IF;
END;
/

/* Different behavior between COUNT and EMPTY when uninitialized */

DECLARE
   TYPE customers_list_t IS TABLE OF VARCHAR2 (30);

   l_customers   customers_list_t;
BEGIN
   /* ORA-06531: Reference to uninitialized collection */
   IF l_customers.COUNT > 0
   THEN
      DBMS_OUTPUT.put_line ('We have customers!');
   END IF;
END;
/

DECLARE
   TYPE customers_list_t IS TABLE OF VARCHAR2 (30);

   l_customers   customers_list_t;
BEGIN
   /* IS EMPTY returns NULL if uninitialized */
   bpl (l_customers IS NOT EMPTY);
END;
/

/* Compare performance of count vs is empty 

   COUNT seems to run a bit slower than IS EMPTY, but the difference
   is only noticeable over MANY iterations.
*/

DECLARE
   l_number       NUMBER;

   TYPE customers_list_t IS TABLE OF VARCHAR2 (30);

   l_customers   customers_list_t
                    := customers_list_t ('Customer 1', 'Customer 3');

   l_start       PLS_INTEGER;

   PROCEDURE mark_start
   IS
   BEGIN
      l_start := DBMS_UTILITY.get_cpu_time;
   END mark_start;

   PROCEDURE show_elapsed (NAME_IN IN VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            '"'
         || NAME_IN
         || '" elapsed CPU time: '
         || TO_CHAR ( (DBMS_UTILITY.get_cpu_time - l_start) / 100)
         || ' seconds');
   END show_elapsed;
BEGIN
   mark_start;

   FOR indx IN 1 .. 10000000
   LOOP
      IF l_customers IS EMPTY
      THEN
         l_number := indx;
      END IF;
   END LOOP;

   show_elapsed ('IS EMPTY 10000000');
   --
   mark_start;

   FOR indx IN 1 .. 10000000
   LOOP
      IF l_customers.COUNT = 0
      THEN
         l_number := indx;
      END IF;
   END LOOP;

   show_elapsed ('COUNT 10000000');
END;
/