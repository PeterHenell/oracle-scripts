/*

Each block fails with an unhandled exception.
Which block will display "Hurray!" after making 
a change to just one declaration?
*/

/* Before
ORA-06531: Reference to uninitialized collection
*/

DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;

   l_numbers   numbers_t;
BEGIN
   IF l_numbers.COUNT > 0
   THEN
      DBMS_OUTPUT.put_line ('empty');
   END IF;

   DBMS_OUTPUT.put_line ('Hurray!');
END;
/

/* After: add index by */

DECLARE
   TYPE numbers_t IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   l_numbers   numbers_t;
BEGIN
   IF l_numbers.COUNT > 0
   THEN
      DBMS_OUTPUT.put_line ('empty');
   END IF;

   DBMS_OUTPUT.put_line ('Hurray!');
END;
/

/* Before
ORA-06531: Reference to uninitialized collection
*/

DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;

   l_index pls_integer;
BEGIN
   IF l_numbers.COUNT > 0
   THEN
      DBMS_OUTPUT.put_line ('empty');
   END IF;

   DBMS_OUTPUT.put_line ('Hurray!');
END;
/