CREATE OR REPLACE PROCEDURE collcompare_test (
   size_in    IN   PLS_INTEGER
 , count_in   IN   PLS_INTEGER := 100000
)
IS
   aa_tmr   tmr_t    := NEW tmr_t ('Associative array', count_in);
   nt_tmr   tmr_t    := NEW tmr_t ('Nested table', count_in);
   va_tmr   tmr_t    := NEW tmr_t ('Varrying array', count_in);

   TYPE aa_t IS TABLE OF VARCHAR2 (100)
      INDEX BY PLS_INTEGER;

   TYPE nt_t IS TABLE OF VARCHAR2 (100);

   TYPE va20_t IS VARRAY (20) OF VARCHAR2 (100);

   TYPE va50_t IS VARRAY (50) OF VARCHAR2 (100);

   TYPE va100_t IS VARRAY (100) OF VARCHAR2 (100);

   TYPE va1000_t IS VARRAY (1000) OF VARCHAR2 (100);

   aa       aa_t;
   nt       nt_t;
   va20     va20_t;
   va50     va50_t;
   va100    va100_t;
   va1000   va1000_t;
BEGIN
   DBMS_OUTPUT.put_line (   'Compare array performance with size set to '
                         || size_in
                        );
   aa_tmr.go;

   FOR indx IN 1 .. count_in
   LOOP
      FOR indx2 IN 1 .. size_in
      LOOP
         aa (indx2) := 'abc';
      END LOOP;
   END LOOP;

   aa_tmr.STOP;
   nt_tmr.go;
   nt := nt_t ();
   nt.EXTEND (size_in);

   FOR indx IN 1 .. count_in
   LOOP
      FOR indx2 IN 1 .. size_in
      LOOP
         nt (indx2) := 'abc';
      END LOOP;
   END LOOP;

   nt_tmr.STOP;

   IF size_in = 20
   THEN
      va_tmr.go;
      va20 := va20_t ();
      va20.EXTEND (size_in);

      FOR indx IN 1 .. count_in
      LOOP
         FOR indx2 IN 1 .. size_in
         LOOP
            va20 (indx2) := 'abc';
         END LOOP;
      END LOOP;

      va_tmr.STOP;
   ELSIF size_in = 50
   THEN
      va_tmr.go;
      va50 := va50_t ();
      va50.EXTEND (size_in);

      FOR indx IN 1 .. count_in
      LOOP
         FOR indx2 IN 1 .. size_in
         LOOP
            va50 (indx2) := 'abc';
         END LOOP;
      END LOOP;

      va_tmr.STOP;
   ELSIF size_in = 100
   THEN
      va_tmr.go;
      va100 := va100_t ();
      va100.EXTEND (size_in);

      FOR indx IN 1 .. count_in
      LOOP
         FOR indx2 IN 1 .. size_in
         LOOP
            va100 (indx2) := 'abc';
         END LOOP;
      END LOOP;

      va_tmr.STOP;
   ELSIF size_in = 1000
   THEN
      va_tmr.go;
      va1000 := va1000_t ();
      va1000.EXTEND (size_in);

      FOR indx IN 1 .. count_in
      LOOP
         FOR indx2 IN 1 .. size_in
         LOOP
            va1000 (indx2) := 'abc';
         END LOOP;
      END LOOP;

      va_tmr.STOP;
   END IF;
END;
/

BEGIN
   collcompare_test (20, 1000000);
   --collcompare_test (50, 100000);
   --collcompare_test (100, 100000);
   --collcompare_test (1000, 100000);
END;
/

/* Results on an IBM Thinkpad T42 running Oracle10g Database Release 1

Number of iterations 100000 unless otherwise noted.

Compare array performance with size set to 20
Timings in seconds for "Associative array":
Elapsed = .48 - per rep .0000048
CPU     = .48 - per rep .0000048
Timings in seconds for "Nested table":
Elapsed = .46 - per rep .0000046
CPU     = .45 - per rep .0000045
Timings in seconds for "Varrying array":
Elapsed = .46 - per rep .0000046
CPU     = .46 - per rep .0000046

Compare array performance with size set to 50
Timings in seconds for "Associative array":
Elapsed = 1.09 - per rep .0000109
CPU     = 1.05 - per rep .0000105
Timings in seconds for "Nested table":
Elapsed = 1.18 - per rep .0000118
CPU     = 1.18 - per rep .0000118
Timings in seconds for "Varrying array":
Elapsed = 1.18 - per rep .0000118
CPU     = 1.19 - per rep .0000119

Compare array performance with size set to 100
Timings in seconds for "Associative array":
Elapsed = 2.13 - per rep .0000213
CPU     = 2.12 - per rep .0000212
Timings in seconds for "Nested table":
Elapsed = 2.26 - per rep .0000226
CPU     = 2.24 - per rep .0000224
Timings in seconds for "Varrying array":
Elapsed = 2.56 - per rep .0000256
CPU     = 2.31 - per rep .0000231

Compare array performance with size set to 1000
Timings in seconds for "Associative array":
Elapsed = 21.65 - per rep .0002165
CPU     = 21.13 - per rep .0002113
Timings in seconds for "Nested table":
Elapsed = 23.31 - per rep .0002331
CPU     = 22.74 - per rep .0002274
Timings in seconds for "Varrying array":
Elapsed = 23.3 - per rep .000233
CPU     = 23.05 - per rep .0002305

Compare array performance with size set to 20 (1000000 iterations)
Timings in seconds for "Associative array":
Elapsed = 4.38 - per rep .00000438
CPU     = 4.31 - per rep .00000431
Timings in seconds for "Nested table":
Elapsed = 4.59 - per rep .00000459
CPU     = 4.56 - per rep .00000456
Timings in seconds for "Varrying array":
Elapsed = 4.94 - per rep .00000494
CPU     = 4.56 - per rep .00000456

*/