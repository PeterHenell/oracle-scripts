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

   FOR indx IN 1 .. count_in
   LOOP
      FOR indx2 IN 1 .. size_in
      LOOP
	     nt.EXTEND;
         nt (indx2) := 'abc';
      END LOOP;
   END LOOP;

   nt_tmr.STOP;

   IF size_in = 20
   THEN
      va_tmr.go;
      va20 := va20_t ();

      FOR indx IN 1 .. count_in
      LOOP
         FOR indx2 IN 1 .. size_in
         LOOP
		    va20.EXTEND;
            va20 (indx2) := 'abc';
         END LOOP;
      END LOOP;

      va_tmr.STOP;
   ELSIF size_in = 50
   THEN
      va_tmr.go;
      va50 := va50_t ();

      FOR indx IN 1 .. count_in
      LOOP
         FOR indx2 IN 1 .. size_in
         LOOP
		    va50.EXTEND;
            va50 (indx2) := 'abc';
         END LOOP;
      END LOOP;

      va_tmr.STOP;
   ELSIF size_in = 100
   THEN
      va_tmr.go;
      va100 := va100_t ();

      FOR indx IN 1 .. count_in
      LOOP
         FOR indx2 IN 1 .. size_in
         LOOP
		    va100.EXTEND;
            va100 (indx2) := 'abc';
         END LOOP;
      END LOOP;

      va_tmr.STOP;
   ELSIF size_in = 1000
   THEN
      va_tmr.go;
      va1000 := va1000_t ();

      FOR indx IN 1 .. count_in
      LOOP
         FOR indx2 IN 1 .. size_in
         LOOP
		    va1000.EXTEND;
            va1000 (indx2) := 'abc';
         END LOOP;
      END LOOP;

      va_tmr.STOP;
   END IF;
END;
/

BEGIN
   collcompare_test (20, 100000);
   collcompare_test (50, 100000);
   collcompare_test (100, 100000);
   collcompare_test (1000, 100000);
END;
/

/* Results on an IBM Thinkpad T42 running Oracle10g Database Release 1

*/