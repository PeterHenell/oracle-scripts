SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE nocopy_test
IS
   TYPE number_nt IS TABLE OF NUMBER;

   PROCEDURE pass_by_value (
      nums IN OUT number_nt, raise_in in boolean);

   PROCEDURE pass_by_ref (
      nums IN OUT NOCOPY number_nt, raise_in in boolean);
END;
/

CREATE OR REPLACE PACKAGE BODY nocopy_test
IS
   PROCEDURE pass_by_value (
      nums IN OUT number_nt, raise_in in boolean)
   IS
   BEGIN
      FOR indx IN nums.FIRST .. nums.LAST
      LOOP
         nums (indx) := nums (indx) * 2;

         IF raise_in and indx > 2
         THEN
            RAISE VALUE_ERROR;
         END IF;
      END LOOP;
   END pass_by_value;

   PROCEDURE pass_by_ref (nums IN OUT NOCOPY number_nt, raise_in in boolean)
   IS
   BEGIN
      FOR indx IN nums.FIRST .. nums.LAST
      LOOP
         nums (indx) := nums (indx) * 2;

         IF raise_in and indx > 2
         THEN
            RAISE VALUE_ERROR;
         END IF;
      END LOOP;
   END pass_by_ref;
END;
/

DECLARE
   nums1   nocopy_test.number_nt := nocopy_test.number_nt (1, 2, 3, 4, 5);
   nums2   nocopy_test.number_nt := nocopy_test.number_nt (1, 2, 3, 4, 5);

   PROCEDURE shownums (str IN VARCHAR2, nums IN nocopy_test.number_nt)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (str);

      FOR indx IN nums.FIRST .. nums.LAST
      LOOP
         DBMS_OUTPUT.put (nums (indx) || '-');
      END LOOP;

      DBMS_OUTPUT.new_line;
   END;
BEGIN
   shownums ('Before By Value', nums1);

   BEGIN
      nocopy_test.pass_by_value (nums1, FALSE);
      shownums ('After By Value no raise', nums1);
   END;

   nums1 := nocopy_test.number_nt (1, 2, 3, 4, 5);
   shownums ('Before By Value', nums1);

   BEGIN
      nocopy_test.pass_by_value (nums1, TRUE);
   EXCEPTION
      WHEN OTHERS
      THEN
         shownums ('After By Value with raise', nums1);
   END;

   shownums ('Before NOCOPY', nums2);

   BEGIN
      nocopy_test.pass_by_ref (nums2, TRUE);
   EXCEPTION
      WHEN OTHERS
      THEN
         shownums ('After NOCOPY with raise', nums2);
   END;
END;
/