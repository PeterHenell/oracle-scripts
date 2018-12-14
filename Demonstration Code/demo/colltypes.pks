CREATE OR REPLACE PACKAGE collection_types
IS
   -- Associative array types
   TYPE boolean_aat IS TABLE OF BOOLEAN
    INDEX BY PLS_INTEGER;

   TYPE date_aat IS TABLE OF DATE
    INDEX BY PLS_INTEGER;

   TYPE pls_integer_aat IS TABLE OF PLS_INTEGER
    INDEX BY PLS_INTEGER;

   TYPE number_aat IS TABLE OF NUMBER
    INDEX BY PLS_INTEGER;

   TYPE identifier_aat IS TABLE OF VARCHAR2(30)
    INDEX BY PLS_INTEGER;

   TYPE vcmax_aat IS TABLE OF VARCHAR2(32767)
    INDEX BY PLS_INTEGER;

   -- Nested table types
   TYPE boolean_ntt IS TABLE OF BOOLEAN;
   TYPE date_ntt IS TABLE OF DATE;
   TYPE pls_integer_ntt IS TABLE OF PLS_INTEGER;
   TYPE number_ntt IS TABLE OF NUMBER;
   TYPE identifier_ntt IS TABLE OF VARCHAR2(30);
   TYPE vcmax_ntt IS TABLE OF VARCHAR2(32767);
END collection_types;
/

