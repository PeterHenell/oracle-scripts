/* 
Discovered by David Alexander, dzalexander@ybs.co.uk
*/

DROP TABLE test_forall
/

CREATE TABLE test_forall (pknum NUMBER (5) PRIMARY KEY);

INSERT ALL
  INTO test_forall
VALUES (1)
  INTO test_forall
VALUES (2)
  INTO test_forall
VALUES (3)
  INTO test_forall
VALUES (4)
  INTO test_forall
VALUES (5)
   SELECT * FROM DUAL;

 -- Attempt to bulk insert the same values, and handle the exceptions

DECLARE
   TYPE tabtype IS TABLE OF test_forall%ROWTYPE
                      INDEX BY PLS_INTEGER;

   tab   tabtype;

   PROCEDURE output_bulk_exceptions
   IS
      ln_errors   NUMBER := 0;
   BEGIN
      ln_errors := SQL%BULK_EXCEPTIONS.COUNT;
      DBMS_OUTPUT.put_line (
         'Number of statements that failed: ' || ln_errors);

      FOR j IN 1 .. ln_errors
      LOOP
         DBMS_OUTPUT.put_line (
               'Error #'
            || j
            || ' occurred during '
            || 'iteration #'
            || SQL%BULK_EXCEPTIONS (j).ERROR_INDEX
            || ' "'
            || SQLERRM (-SQL%BULK_EXCEPTIONS (j).ERROR_CODE)
            || '"');
      END LOOP;
   END;

   PROCEDURE process_bulk_rowcount
   IS
      j        BINARY_INTEGER;
      ln_dml   NUMBER (5) := 0;
   BEGIN
      DBMS_OUTPUT.put_line ('Total updated: ' || SQL%ROWCOUNT);
      j := tab.FIRST;

      WHILE j IS NOT NULL
      LOOP
         BEGIN
            ln_dml := ln_dml + SQL%BULK_ROWCOUNT (j);
            DBMS_OUTPUT.put_line (j || '  (' || SQL%BULK_ROWCOUNT (j) || ')');
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  j || ' does not exist in SQL%BULK_ROWCOUNT?!?');
         END;

         j := tab.NEXT (j);
      END LOOP;

      DBMS_OUTPUT.put_line (ln_dml || ' records inserted');
   END;
-- ----------
BEGIN
   tab (1).pknum := 1;
   tab (2).pknum := 2;
   tab (3).pknum := 3;
   tab (4).pknum := 4;
   tab (5).pknum := 5;

   -- Going to get Primary Key Violations
   BEGIN
      FORALL i IN tab.FIRST .. tab.LAST SAVE EXCEPTIONS
         INSERT INTO test_forall
              VALUES tab (i);
   EXCEPTION
      WHEN OTHERS
      THEN -- Now we figure out what failed and why.
         process_bulk_rowcount;
         output_bulk_exceptions;
   END;

   -- Going to get Primary Key Violations
   BEGIN
      FORALL i IN INDICES OF tab SAVE EXCEPTIONS
         INSERT INTO test_forall
              VALUES tab (i);
   EXCEPTION
      WHEN OTHERS
      THEN -- Now we figure out what failed and why.
         process_bulk_rowcount;
         output_bulk_exceptions;
   END;

   ROLLBACK;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
END;
/