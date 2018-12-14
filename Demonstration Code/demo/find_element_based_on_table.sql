DROP TABLE products
/
CREATE TABLE products (
   product_number INTEGER PRIMARY KEY,
   product_name VARCHAR2(100) UNIQUE
)
/

BEGIN
   INSERT INTO products
        VALUES (100, 'Stapler');

   INSERT INTO products
        VALUES (200, 'Packing Tape');

   INSERT INTO products
        VALUES (300, 'Keyboard');

   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE office_products
IS
   TYPE names_list_aat IS TABLE OF VARCHAR2 (100)
      INDEX BY PLS_INTEGER;

   list_of_names   names_list_aat;
END office_products;
/

CREATE OR REPLACE PACKAGE BODY office_products
IS
BEGIN
   FOR product_rec IN (SELECT *
                         FROM products)
   LOOP
      list_of_names (product_rec.product_number) := product_rec.product_name;
   END LOOP;
END office_products;
/

CREATE OR REPLACE FUNCTION product_lookup1 (NAME_IN IN VARCHAR2)
   RETURN PLS_INTEGER
IS
   c_count    PLS_INTEGER := office_products.list_of_names.COUNT;
   l_index    PLS_INTEGER := office_products.list_of_names.FIRST;
   l_return   PLS_INTEGER;
BEGIN
   WHILE (l_index IS NOT NULL)
   LOOP
      IF office_products.list_of_names (l_index) = NAME_IN
      THEN
         l_return := l_index;
         l_index := NULL;
      ELSE
         l_index := office_products.list_of_names.NEXT (l_index);
      END IF;
   END LOOP;

   RETURN l_return;
END product_lookup1;
/

CREATE OR REPLACE PACKAGE office_products
IS
   SUBTYPE index_t IS PLS_INTEGER;

   TYPE names_list_aat IS TABLE OF products.product_name%TYPE
      INDEX BY index_t;

   TYPE index_list_aat IS TABLE OF index_t
      INDEX BY products.product_name%TYPE;

   list_of_names   names_list_aat;
   index_by_name   index_list_aat;
END office_products;
/

CREATE OR REPLACE PACKAGE BODY office_products
IS
   PROCEDURE initialize
   IS
      TYPE products_aat IS TABLE OF products%ROWTYPE
         INDEX BY PLS_INTEGER;

      l_products   products_aat;

      PROCEDURE add_product (product_in IN products%ROWTYPE)
      IS
      BEGIN
         list_of_names (product_in.product_number) := product_in.product_name;
         index_by_name (product_in.product_name) := product_in.product_number;
      END add_product;
   BEGIN
      SELECT *
      BULK COLLECT INTO l_products
        FROM products;

      FOR indx IN 1 .. l_products.COUNT
      LOOP
         add_product (l_products (indx));
      END LOOP;
   END initialize;
BEGIN
   initialize;
END office_products;
/

CREATE OR REPLACE FUNCTION product_lookup2 (
   NAME_IN   IN   products.product_name%TYPE
)
   RETURN PLS_INTEGER
IS
   l_index   PLS_INTEGER;
BEGIN
   IF office_products.index_by_name.EXISTS (NAME_IN)
   THEN
      l_index := office_products.index_by_name (NAME_IN);
   END IF;

   RETURN l_index;
END product_lookup2;
/

/* Now let's do some performance analysis...
   Load up LOTS of "languages" and compare lookup time. 
*/

CREATE OR REPLACE PACKAGE office_products
IS
   SUBTYPE index_t IS PLS_INTEGER;

   TYPE names_list_aat IS TABLE OF products.product_name%TYPE
      INDEX BY index_t;

   TYPE index_list_aat IS TABLE OF index_t
      INDEX BY products.product_name%TYPE;

   list_of_names   names_list_aat;
   index_by_name   index_list_aat;

   PROCEDURE initialize (count_in IN PLS_INTEGER);
END office_products;
/

CREATE OR REPLACE PACKAGE BODY office_products
IS
   PROCEDURE initialize (count_in IN PLS_INTEGER)
   IS
      TYPE products_aat IS TABLE OF products%ROWTYPE
         INDEX BY PLS_INTEGER;

      l_products   products_aat;
      l_record     products%ROWTYPE;

      PROCEDURE add_product (product_in IN products%ROWTYPE)
      IS
      BEGIN
         list_of_names (product_in.product_number) := product_in.product_name;
         index_by_name (product_in.product_name) := product_in.product_number;
      END add_product;
   BEGIN
      list_of_names.DELETE;
      index_by_name.DELETE;

      SELECT *
      BULK COLLECT INTO l_products
        FROM products;

      FOR indx IN 1 .. l_products.COUNT
      LOOP
         add_product (l_products (indx));
      END LOOP;

      FOR indx IN 1 .. count_in
      LOOP
         l_record.product_number := indx * 1000;
         l_record.product_name := 'Product ' || indx;
         add_product (l_record);
      END LOOP;
   END initialize;
END office_products;
/

CREATE OR REPLACE PROCEDURE compare_lookups (
   coll_count_in   IN   PLS_INTEGER
 , iterations_in   IN   PLS_INTEGER
)
IS
   l_time_before   PLS_INTEGER;
   l_index         PLS_INTEGER;
BEGIN
   office_products.initialize (coll_count_in);
   --
   DBMS_OUTPUT.put_line ('Collection Lookup Performance Analysis');
   DBMS_OUTPUT.put_line ('COUNT in collections = ' || coll_count_in);
   DBMS_OUTPUT.put_line (   'Number of times program lookup called = '
                         || iterations_in
                        );
   --
   l_time_before := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. iterations_in
   LOOP
      l_index := product_lookup1 ('Product ' || TO_CHAR (coll_count_in / 2));
   END LOOP;

   DBMS_OUTPUT.put_line (   '   Scan Find - name exists = '
                         || TO_CHAR (DBMS_UTILITY.get_cpu_time - l_time_before)
                        );
   --
   l_time_before := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. iterations_in
   LOOP
      l_index := product_lookup1 ('Product XYZ');
   END LOOP;

   DBMS_OUTPUT.put_line (   '   Scan Find - name does not exist = '
                         || TO_CHAR (DBMS_UTILITY.get_cpu_time - l_time_before)
                        );
   --
   l_time_before := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. iterations_in
   LOOP
      l_index := product_lookup2 ('Product ' || TO_CHAR (coll_count_in / 2));
   END LOOP;

   DBMS_OUTPUT.put_line (   '   Index Find - name exists = '
                         || TO_CHAR (DBMS_UTILITY.get_cpu_time - l_time_before)
                        );
   --
   l_time_before := DBMS_UTILITY.get_cpu_time;

   FOR indx IN 1 .. iterations_in
   LOOP
      l_index := product_lookup2 ('Product XYZ');
   END LOOP;

   DBMS_OUTPUT.put_line (   '   Index Find - name does not exist = '
                         || TO_CHAR (DBMS_UTILITY.get_cpu_time - l_time_before)
                        );
END compare_lookups;
/

BEGIN
   compare_lookups (100, 1000);
   compare_lookups (1000, 1000);
--   compare_lookups (100000, 1000);
--   compare_lookups (100000, 10000);
END;
/