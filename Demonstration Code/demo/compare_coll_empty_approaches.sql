DECLARE
   l_number      NUMBER;

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
   DBMS_OUTPUT.put_line ('Non-Empty Collection');
   mark_start;

   FOR indx IN 1 .. 100000000
   LOOP
      IF l_customers IS EMPTY
      THEN
         l_number := indx;
      END IF;
   END LOOP;

   show_elapsed ('IS EMPTY');
   --
   mark_start;

   FOR indx IN 1 .. 100000000
   LOOP
      IF l_customers.COUNT = 0
      THEN
         l_number := indx;
      END IF;
   END LOOP;

   show_elapsed ('COUNT');
   --
   mark_start;

   FOR indx IN 1 .. 100000000
   LOOP
      IF CARDINALITY (l_customers) = 0
      THEN
         l_number := indx;
      END IF;
   END LOOP;

   show_elapsed ('CARDINALITY');

   DBMS_OUTPUT.put_line ('Empty Collection');

   mark_start;

   FOR indx IN 1 .. 100000000
   LOOP
      IF l_customers IS EMPTY
      THEN
         l_number := indx;
      END IF;
   END LOOP;

   show_elapsed ('IS EMPTY');
   --
   mark_start;

   FOR indx IN 1 .. 100000000
   LOOP
      IF l_customers.COUNT = 0
      THEN
         l_number := indx;
      END IF;
   END LOOP;

   show_elapsed ('COUNT');
   --
   mark_start;

   FOR indx IN 1 .. 100000000
   LOOP
      IF CARDINALITY (l_customers) = 0
      THEN
         l_number := indx;
      END IF;
   END LOOP;

   show_elapsed ('CARDINALITY');
END;
/

/*
Non-Empty Collection
"IS EMPTY" elapsed CPU time: 2.29 seconds
"COUNT" elapsed CPU time: 3.23 seconds
"CARDINALITY" elapsed CPU time: 3.09 seconds

Empty Collection
"IS EMPTY" elapsed CPU time: 2.29 seconds
"COUNT" elapsed CPU time: 3.18 seconds
"CARDINALITY" elapsed CPU time: 3.06 seconds
*/