CREATE OR REPLACE PACKAGE nocopy_test
IS
   TYPE num_tabtype IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   PROCEDURE pass_by_value (
      nums        IN OUT   num_tabtype
    , raise_err   IN       BOOLEAN := FALSE
   );

   PROCEDURE pass_by_ref (
      nums        IN OUT NOCOPY   num_tabtype
    , raise_err   IN              BOOLEAN := FALSE
   );

   PROCEDURE compare_methods (num IN PLS_INTEGER);
END;
/

CREATE OR REPLACE PACKAGE BODY nocopy_test
IS
   PROCEDURE pass_by_value (
      nums        IN OUT   num_tabtype
    , raise_err   IN       BOOLEAN := FALSE
   )
   IS
   BEGIN
      FOR indx IN nums.FIRST .. nums.LAST
      LOOP
         nums (indx) := nums (indx) * 2;
      END LOOP;

      IF raise_err
      THEN
         RAISE VALUE_ERROR;
      END IF;
   END;

   PROCEDURE pass_by_ref (
      nums        IN OUT NOCOPY   num_tabtype
    , raise_err   IN              BOOLEAN := FALSE
   )
   IS
   BEGIN
      FOR indx IN nums.FIRST .. nums.LAST
      LOOP
         nums (indx) := nums (indx) * 2;
      END LOOP;

      IF raise_err
      THEN
         RAISE VALUE_ERROR;
      END IF;
   END;

   PROCEDURE compare_methods (num IN PLS_INTEGER)
   IS
      numtab   num_tabtype;

      PROCEDURE loadtab
      IS
      BEGIN
         DBMS_SESSION.free_unused_user_memory;
         numtab.DELETE;

         FOR indx IN 1 .. 100000
         LOOP
            numtab (indx) := indx;
         END LOOP;
      END;
   BEGIN
      loadtab;
      sf_timer.start_timer;

      FOR indx IN 1 .. num
      LOOP
         pass_by_value (numtab, FALSE);
      END LOOP;

      sf_timer.show_elapsed_time ('By value without error ' || num);
      loadtab;
      sf_timer.start_timer;

      FOR indx IN 1 .. num
      LOOP
         pass_by_ref (numtab, FALSE);
      END LOOP;

      sf_timer.show_elapsed_time ('NOCOPY without error ' || num);
      loadtab;
      sf_timer.start_timer;

      BEGIN
         FOR indx IN 1 .. num
         LOOP
            pass_by_value (numtab, TRUE);
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            sf_timer.show_elapsed_time ('By value raising error ' || num);
            DBMS_OUTPUT.put_line (numtab (numtab.FIRST));
      END;

      loadtab;
      sf_timer.start_timer;

      BEGIN
         FOR indx IN 1 .. num
         LOOP
            pass_by_ref (numtab, TRUE);
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            sf_timer.show_elapsed_time ('NOCOPY raising error ' || num);
            DBMS_OUTPUT.put_line (numtab (numtab.FIRST));
      END;
   END;
END;
/

BEGIN
   nocopy_test.compare_methods (10);
   nocopy_test.compare_methods (1000);
   
/*
Oracle 10g Release 2:
    By value without error 1000 Elapsed: 20.49 seconds.
    NOCOPY without error 1000 Elapsed: 12.32 seconds
    
11.2

By value without error 1000" completed in: 11.84 seconds
"NOCOPY without error 1000" completed in: 8.05 seconds

12.1

By value without error 1000 - Elapsed CPU : 11.3 seconds. Factored: .00011 seconds.
NOCOPY without error 1000 - Elapsed CPU : 7.24 seconds. Factored: .00007 seconds.
    
*/
END;
/