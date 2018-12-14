CREATE OR REPLACE PACKAGE changer
IS
   TYPE number_ntt IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;

   PROCEDURE remove_odd_rows (nums IN OUT NOCOPY number_ntt);
END changer;
/

CREATE OR REPLACE PACKAGE BODY changer
IS
   PROCEDURE remove_odd_rows (nums IN OUT NOCOPY number_ntt)
   IS
   BEGIN
      FOR indx IN 1 .. nums.COUNT
      LOOP
         IF MOD (indx, 2) = 0
         THEN
            nums.delete (indx);
         END IF;

         IF indx > 5
         THEN
            RAISE PROGRAM_ERROR;
         END IF;
      END LOOP;
   END;
END changer;
/

BEGIN
   nocopy_test.compare_methods (10);
   nocopy_test.compare_methods (100);
   nocopy_test.compare_methods (1000);
END;
/