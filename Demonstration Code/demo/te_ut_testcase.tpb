CREATE OR REPLACE PACKAGE BODY te_ut_testcase_tst
IS
   g_norow UT_TESTCASE%ROWTYPE;
   g_norow_set BOOLEAN := FALSE;

   -- Display header for a new set of information.
   PROCEDURE newset (str IN VARCHAR2, gr IN VARCHAR2 := '=') IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE (RPAD (gr, 60, gr));
      DBMS_OUTPUT.PUT_LINE (str);
      DBMS_OUTPUT.PUT_LINE (RPAD (gr, 60, gr));
   END;

   -- Show the contents of a table record.
   PROCEDURE showrow (row_in IN UT_TESTCASE%ROWTYPE) IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('**COL ID: ' || row_in.ID);
      DBMS_OUTPUT.PUT_LINE ('**COL UNITTEST_ID: ' || row_in.UNITTEST_ID);
      DBMS_OUTPUT.PUT_LINE ('**COL NAME: ' || row_in.NAME);
      DBMS_OUTPUT.PUT_LINE ('**COL SEQ: ' || row_in.SEQ);
      DBMS_OUTPUT.PUT_LINE ('**COL DESCRIPTION: ' || row_in.DESCRIPTION);
      DBMS_OUTPUT.PUT_LINE ('**COL STATUS: ' || row_in.STATUS);
      DBMS_OUTPUT.PUT_LINE ('**COL DECLARATIONS: ' || row_in.DECLARATIONS);
      DBMS_OUTPUT.PUT_LINE ('**COL SETUP: ' || row_in.SETUP);
      DBMS_OUTPUT.PUT_LINE ('**COL TEARDOWN: ' || row_in.TEARDOWN);
      DBMS_OUTPUT.PUT_LINE ('**COL EXCEPTIONS: ' || row_in.EXCEPTIONS);
      DBMS_OUTPUT.PUT_LINE ('**COL TEST_ID: ' || row_in.TEST_ID);
      DBMS_OUTPUT.PUT_LINE ('**COL PREFIX: ' || row_in.PREFIX);
      DBMS_OUTPUT.PUT_LINE ('**COL ASSERTION: ' || row_in.ASSERTION);
      DBMS_OUTPUT.PUT_LINE ('**COL INLINE_ASSERTION_CALL: ' || row_in.INLINE_ASSERTION_CALL);
      DBMS_OUTPUT.PUT_LINE ('**COL EXECUTIONS: ' || row_in.EXECUTIONS);
      DBMS_OUTPUT.PUT_LINE ('**COL FAILURES: ' || row_in.FAILURES);
      DBMS_OUTPUT.PUT_LINE ('**COL LAST_START: ' || row_in.LAST_START);
      DBMS_OUTPUT.PUT_LINE ('**COL LAST_END: ' || row_in.LAST_END);
   END;

   -- Sets contents of record that does NOT match a row in the database table.
   PROCEDURE set_norow (
      id_in IN UT_TESTCASE.ID%TYPE
      ,unittest_id_in IN UT_TESTCASE.UNITTEST_ID%TYPE DEFAULT NULL
      ,name_in IN UT_TESTCASE.NAME%TYPE DEFAULT NULL
      ,seq_in IN UT_TESTCASE.SEQ%TYPE DEFAULT 1
      ,description_in IN UT_TESTCASE.DESCRIPTION%TYPE DEFAULT NULL
      ,status_in IN UT_TESTCASE.STATUS%TYPE DEFAULT NULL
      ,declarations_in IN UT_TESTCASE.DECLARATIONS%TYPE DEFAULT NULL
      ,setup_in IN UT_TESTCASE.SETUP%TYPE DEFAULT NULL
      ,teardown_in IN UT_TESTCASE.TEARDOWN%TYPE DEFAULT NULL
      ,exceptions_in IN UT_TESTCASE.EXCEPTIONS%TYPE DEFAULT NULL
      ,test_id_in IN UT_TESTCASE.TEST_ID%TYPE DEFAULT NULL
      ,prefix_in IN UT_TESTCASE.PREFIX%TYPE DEFAULT NULL
      ,assertion_in IN UT_TESTCASE.ASSERTION%TYPE DEFAULT NULL
      ,inline_assertion_call_in IN UT_TESTCASE.INLINE_ASSERTION_CALL%TYPE DEFAULT 'N'
      ,executions_in IN UT_TESTCASE.EXECUTIONS%TYPE DEFAULT NULL
      ,failures_in IN UT_TESTCASE.FAILURES%TYPE DEFAULT NULL
      ,last_start_in IN UT_TESTCASE.LAST_START%TYPE DEFAULT NULL
      ,last_end_in IN UT_TESTCASE.LAST_END%TYPE DEFAULT NULL
      )
   IS
   BEGIN
      newset ('Defining "No Row" Values for Primary and Foreign Keys');
      g_norow.ID := id_in;
      g_norow.UNITTEST_ID := unittest_id_in;
      g_norow.NAME := name_in;
      g_norow.SEQ := seq_in;
      g_norow.DESCRIPTION := description_in;
      g_norow.STATUS := status_in;
      g_norow.DECLARATIONS := declarations_in;
      g_norow.SETUP := setup_in;
      g_norow.TEARDOWN := teardown_in;
      g_norow.EXCEPTIONS := exceptions_in;
      g_norow.TEST_ID := test_id_in;
      g_norow.PREFIX := prefix_in;
      g_norow.ASSERTION := assertion_in;
      g_norow.INLINE_ASSERTION_CALL := inline_assertion_call_in;
      g_norow.EXECUTIONS := executions_in;
      g_norow.FAILURES := failures_in;
      g_norow.LAST_START := last_start_in;
      g_norow.LAST_END := last_end_in;
      g_norow_set := TRUE;
   END;

   FUNCTION norowset RETURN BOOLEAN
   IS
   BEGIN
      RETURN g_norow_set;
   END;

   -- Test unique index related functionality.
   PROCEDURE uind (maxrows IN INTEGER := NULL)
   IS
      v_row UT_TESTCASE%ROWTYPE;

      --// Test record structures and functions to retrieve rows. --//
      ut_testcase_idx1_r te_ut_testcase.ut_testcase_idx1_rt;
      v_pky te_ut_testcase.pky_rt;
   BEGIN
      newset ('Unique Index-Related Fetch Activity', '*');

      -- Exercise "by primary key" cursor
      FOR rec IN te_ut_testcase.allbypky_cur
      LOOP
         EXIT WHEN te_ut_testcase.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         -- Perform a lookup based on the primary key values.
         v_pky := te_ut_testcase.ut_testcase_idx1$pky (
            rec.NAME
            );

         -- Display contents to verify the results.
         DBMS_OUTPUT.PUT_LINE ('Primary key from UT_TESTCASE_IDX1:');
         DBMS_OUTPUT.PUT_LINE ('**IND NAME: ' || rec.NAME);
         DBMS_OUTPUT.PUT_LINE ('**PKY ID: ' || v_pky.id);

         -- If user has set a "no row", use it to test a failed lookup
         -- by primary key.
         IF norowset
         THEN
            v_pky := te_ut_testcase.ut_testcase_idx1$pky (
               g_norow.NAME
              );

            -- If primary key is null, then the lookup failed.
            IF te_ut_testcase.isnullpky (v_pky)
            THEN
               DBMS_OUTPUT.PUT_LINE ('"No row" value from UT_TESTCASE_IDX1 is invalid/NULL.');
            END IF;
         END IF;

         newset ('Look up index entry for a primary key.');

         -- Use the primary key to return an index entry
         ut_testcase_idx1_r := te_ut_testcase.ut_testcase_idx1$val (
            rec.ID
            );

         DBMS_OUTPUT.PUT_LINE ('Index ut_testcase_idx1 values from Primary Key');
         DBMS_OUTPUT.PUT_LINE ('**PKY ID: ' || rec.ID);
         DBMS_OUTPUT.PUT_LINE ('**IND NAME: ' || ut_testcase_idx1_r.name);

         newset ('Look up row for unique index');

         -- Get all row information for the contents of a unique index entry.
         v_row := te_ut_testcase.ut_testcase_idx1$row (
            rec.NAME
            );
         DBMS_OUTPUT.PUT_LINE ('Entire row from UT_TESTCASE_IDX1:');
         DBMS_OUTPUT.PUT_LINE ('**IND NAME: ' || rec.NAME);
         showrow (v_row);

      END LOOP;
   END uind;

   PROCEDURE pky (maxrows IN INTEGER := NULL)
   IS
      v_row te_ut_testcase.allforpky_cur%ROWTYPE;

      v_pky te_ut_testcase.pky_rt;

   BEGIN
      newset ('Primary Key-Related Activity', '*');

      -- Use the by primary key cursor.
      FOR rec IN te_ut_testcase.allbypky_cur
      LOOP
         EXIT WHEN te_ut_testcase.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         newset ('Cursor by primary key');

         -- Open the cursor for the current primary key and fetch the row
         -- it identifies.

         OPEN te_ut_testcase.allforpky_cur (
            rec.ID
            );

         FETCH te_ut_testcase.allforpky_cur INTO v_row;

         DBMS_OUTPUT.PUT_LINE ('**PKY ID: ' || v_row.ID);

         IF te_ut_testcase.allforpky_cur%NOTFOUND
         THEN
            DBMS_OUTPUT.PUT_LINE ('!! Row not found for primary key.');
         ELSE
            DBMS_OUTPUT.PUT_LINE ('Row found for primary key');
            DBMS_OUTPUT.PUT_LINE ('**COL UNITTEST_ID: ' || v_row.UNITTEST_ID);
            DBMS_OUTPUT.PUT_LINE ('**COL NAME: ' || v_row.NAME);
            DBMS_OUTPUT.PUT_LINE ('**COL SEQ: ' || v_row.SEQ);
            DBMS_OUTPUT.PUT_LINE ('**COL DESCRIPTION: ' || v_row.DESCRIPTION);
            DBMS_OUTPUT.PUT_LINE ('**COL STATUS: ' || v_row.STATUS);
            DBMS_OUTPUT.PUT_LINE ('**COL DECLARATIONS: ' || v_row.DECLARATIONS);
            DBMS_OUTPUT.PUT_LINE ('**COL SETUP: ' || v_row.SETUP);
            DBMS_OUTPUT.PUT_LINE ('**COL TEARDOWN: ' || v_row.TEARDOWN);
            DBMS_OUTPUT.PUT_LINE ('**COL EXCEPTIONS: ' || v_row.EXCEPTIONS);
            DBMS_OUTPUT.PUT_LINE ('**COL TEST_ID: ' || v_row.TEST_ID);
            DBMS_OUTPUT.PUT_LINE ('**COL PREFIX: ' || v_row.PREFIX);
            DBMS_OUTPUT.PUT_LINE ('**COL ASSERTION: ' || v_row.ASSERTION);
            DBMS_OUTPUT.PUT_LINE ('**COL INLINE_ASSERTION_CALL: ' || v_row.INLINE_ASSERTION_CALL);
            DBMS_OUTPUT.PUT_LINE ('**COL EXECUTIONS: ' || v_row.EXECUTIONS);
            DBMS_OUTPUT.PUT_LINE ('**COL FAILURES: ' || v_row.FAILURES);
            DBMS_OUTPUT.PUT_LINE ('**COL LAST_START: ' || v_row.LAST_START);
            DBMS_OUTPUT.PUT_LINE ('**COL LAST_END: ' || v_row.LAST_END);
         END IF;

         -- Close the cursor.
         te_ut_testcase.close_allforpky_cur;

      END LOOP;
   END pky;

   -- Test FKY related functionality.
   PROCEDURE fky (maxrows IN INTEGER := NULL)
   IS
      v_pky UT_TESTCASE.id%TYPE;
      -- Declare a cursor to obtain distinct foreign key values in the table.
      CURSOR ut_testcase_unitest_fk_all_cur
      IS
         SELECT DISTINCT
             UNITTEST_ID
           FROM UT_TESTCASE;
   BEGIN
      newset ('Foreign Key-Related Activity', '*');

      -- For each value in this foreign key cursor...
      FOR Orec IN ut_testcase_unitest_fk_all_cur
      LOOP
         EXIT WHEN ut_testcase_unitest_fk_all_cur%ROWCOUNT > NVL (maxrows, 5);
         newset ('Retrieve Data for Foreign Key ut_testcase_unitest_fk');
         DBMS_OUTPUT.PUT_LINE ('**FKY UNITTEST_ID: ' || Orec.UNITTEST_ID);
         -- Display all records identified for that foreign key.
         FOR Irec IN te_ut_testcase.ut_testcase_unitest_fk_all_cur (
            Orec.UNITTEST_ID
            )
         LOOP
            IF te_ut_testcase.ut_testcase_unitest_fk_all_cur%ROWCOUNT > NVL (maxrows, 5)
            THEN
               --// Test close cursor program and then exit. --//
               te_ut_testcase.close_ut_testcase_unitest_fk_a;
               EXIT;
            ELSE
               showrow (Irec);
            END IF;
         END LOOP;
      END LOOP;
   END fky;

   -- Test lookup functionality
   PROCEDURE lookups (maxrows IN INTEGER := NULL)
   IS
      v_row UT_TESTCASE%ROWTYPE;

   BEGIN
      newset ('Retrieve one row at a time.', '*');

      FOR rec IN te_ut_testcase.allbypky_cur
      LOOP
         EXIT WHEN te_ut_testcase.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         newset ('Retrieve and display row and desc columns for primary key.');

         DBMS_OUTPUT.PUT_LINE ('**PKY ID: ' || rec.ID);

         -- Use onerow function to lookup row for this primary key value.
         v_row := te_ut_testcase.onerow (
            rec.ID
            );

         IF NOT te_ut_testcase.isnullpky (v_row)
         THEN
            showrow (v_row);
         ELSE
            DBMS_OUTPUT.PUT_LINE ('!! Row not found for primary key.');
         END IF;
      END LOOP;


   END lookups;

   -- Test the validation programs.
   PROCEDURE validate
   IS
      v_row UT_TESTCASE%ROWTYPE;
      v_valuesOK BOOLEAN;
      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('No check constraints to validate.');
   END validate;

   -- Test insert activity.
   PROCEDURE ins (maxrows IN INTEGER := NULL)
   IS
      v_row UT_TESTCASE%ROWTYPE;
      v_pky te_ut_testcase.pky_rt;
      v_pkycol INTEGER;
      v_nxtpky INTEGER;

      --// Variable for every primary key column //--
      v_ID UT_TESTCASE.ID%TYPE;

      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
   BEGIN
      newset ('INS: function-based record init');
      v_row := te_ut_testcase.initrec;
      showrow (v_row);

      newset ('INS: procedure-based record init');
      te_ut_testcase.initrec (v_row);
      showrow (v_row);

      ROLLBACK;

      newset ('INS: Pass in primary key');

      te_ut_testcase.ins (
         v_ID,
         22,
         SUBSTR ('NAME', 1, 200),
         22,
         SUBSTR ('DESCRIPTION', 1, 2000),
         SUBSTR ('STATUS', 1, 20),
         SUBSTR ('DECLARATIONS', 1, 2000),
         SUBSTR ('SETUP', 1, 2000),
         SUBSTR ('TEARDOWN', 1, 2000),
         SUBSTR ('EXCEPTIONS', 1, 2000),
         22,
         SUBSTR ('PREFIX', 1, 200),
         SUBSTR ('ASSERTION', 1, 100),
         SUBSTR ('INLINE_ASSERTION_CALL', 1, 1),
         22,
         22,
         SYSDATE,
         SYSDATE,
         FALSE
         );

      ROLLBACK;

      newset ('INS: Record-based insert');

      --// Populate the row! //--
      te_ut_testcase.ins (v_row,
         FALSE
         );

      ROLLBACK;
      FOR rec IN te_ut_testcase.allbypky_cur
      LOOP
         EXIT WHEN te_ut_testcase.allbypky_cur%ROWCOUNT > 1;

         --// Move primary key information to the PKY record. //--
         v_pky.id := rec.ID;

         --// Try to reinsert same record with update-on-dup option. //--
         --// Double all nonprimary key column values. //--
         v_row.UNITTEST_ID :=
            v_row.UNITTEST_ID + v_row.UNITTEST_ID;
         v_row.NAME :=
            SUBSTR (v_row.NAME || v_row.NAME, 1, 200);
         v_row.SEQ :=
            v_row.SEQ + v_row.SEQ;
         v_row.DESCRIPTION :=
            SUBSTR (v_row.DESCRIPTION || v_row.DESCRIPTION, 1, 2000);
         v_row.STATUS :=
            SUBSTR (v_row.STATUS || v_row.STATUS, 1, 20);
         v_row.DECLARATIONS :=
            SUBSTR (v_row.DECLARATIONS || v_row.DECLARATIONS, 1, 2000);
         v_row.SETUP :=
            SUBSTR (v_row.SETUP || v_row.SETUP, 1, 2000);
         v_row.TEARDOWN :=
            SUBSTR (v_row.TEARDOWN || v_row.TEARDOWN, 1, 2000);
         v_row.EXCEPTIONS :=
            SUBSTR (v_row.EXCEPTIONS || v_row.EXCEPTIONS, 1, 2000);
         v_row.TEST_ID :=
            v_row.TEST_ID + v_row.TEST_ID;
         v_row.PREFIX :=
            SUBSTR (v_row.PREFIX || v_row.PREFIX, 1, 200);
         v_row.ASSERTION :=
            SUBSTR (v_row.ASSERTION || v_row.ASSERTION, 1, 100);
         v_row.INLINE_ASSERTION_CALL :=
            SUBSTR (v_row.INLINE_ASSERTION_CALL || v_row.INLINE_ASSERTION_CALL, 1, 1);
         v_row.EXECUTIONS :=
            v_row.EXECUTIONS + v_row.EXECUTIONS;
         v_row.FAILURES :=
            v_row.FAILURES + v_row.FAILURES;
         v_row.LAST_START :=
            v_row.LAST_START + (v_row.LAST_START - TRUNC (v_row.LAST_START, 'YY'));
         v_row.LAST_END :=
            v_row.LAST_END + (v_row.LAST_END - TRUNC (v_row.LAST_END, 'YY'));

         te_ut_testcase.ins (v_row,
            TRUE
            );

          ROLLBACK;

         --// Try to reinsert same record with no-update option. //--
         te_ut_testcase.ins (v_row,
            FALSE
            );

          ROLLBACK;
       END LOOP;
   END ins;
   PROCEDURE upd (maxrows IN INTEGER := NULL)
   IS
      v_row UT_TESTCASE%ROWTYPE;
      v_pky te_ut_testcase.pky_rt;
      v_UNITTEST_ID UT_TESTCASE.UNITTEST_ID%TYPE;
      v_NAME UT_TESTCASE.NAME%TYPE;
      v_SEQ UT_TESTCASE.SEQ%TYPE;
      v_DESCRIPTION UT_TESTCASE.DESCRIPTION%TYPE;
      v_STATUS UT_TESTCASE.STATUS%TYPE;
      v_DECLARATIONS UT_TESTCASE.DECLARATIONS%TYPE;
      v_SETUP UT_TESTCASE.SETUP%TYPE;
      v_TEARDOWN UT_TESTCASE.TEARDOWN%TYPE;
      v_EXCEPTIONS UT_TESTCASE.EXCEPTIONS%TYPE;
      v_TEST_ID UT_TESTCASE.TEST_ID%TYPE;
      v_PREFIX UT_TESTCASE.PREFIX%TYPE;
      v_ASSERTION UT_TESTCASE.ASSERTION%TYPE;
      v_INLINE_ASSERTION_CALL UT_TESTCASE.INLINE_ASSERTION_CALL%TYPE;
      v_EXECUTIONS UT_TESTCASE.EXECUTIONS%TYPE;
      v_FAILURES UT_TESTCASE.FAILURES%TYPE;
      v_LAST_START UT_TESTCASE.LAST_START%TYPE;
      v_LAST_END UT_TESTCASE.LAST_END%TYPE;

      v_errnum INTEGER;
      v_errmsg VARCHAR2(2000);
      v_rowcount INTEGER;
   BEGIN
      newset ('UPD: Update Processing', '*');

      FOR rec IN te_ut_testcase.allbypky_cur
      LOOP
         EXIT WHEN te_ut_testcase.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);

         --// Move primary key information to the PKY record. //--
         v_pky.id := rec.ID;

         newset ('UPD: Turn off all force fields with reset, update all NULLs');
         te_ut_testcase.reset$frc;
         te_ut_testcase.upd (
           rec.ID,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           v_rowcount,
           TRUE
           );

         DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || v_rowcount);
         ROLLBACK;

         newset ('UPD: Turn on force fields, update all NULLs');
         te_ut_testcase.upd (
           rec.ID,
           1,
           'a',
           1,
           'a',
           'a',
           'a',
           'a',
           'a',
           'a',
           1,
           'a',
           'a',
           'a',
           1,
           1,
           SYSDATE,
           SYSDATE,
           v_rowcount,
           TRUE
           );

         DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || v_rowcount);

         ROLLBACK;

         newset ('UPD: Record-based Update');

         te_ut_testcase.upd (v_row,
           v_rowcount,
           TRUE
           );

         DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || v_rowcount);
      END LOOP;
   END upd;


   PROCEDURE del (maxrows IN INTEGER := NULL)
   IS
      v_pky te_ut_testcase.pky_rt;
      v_UNITTEST_ID UT_TESTCASE.UNITTEST_ID%TYPE;
      v_NAME UT_TESTCASE.NAME%TYPE;
      v_SEQ UT_TESTCASE.SEQ%TYPE;
      v_DESCRIPTION UT_TESTCASE.DESCRIPTION%TYPE;
      v_STATUS UT_TESTCASE.STATUS%TYPE;
      v_DECLARATIONS UT_TESTCASE.DECLARATIONS%TYPE;
      v_SETUP UT_TESTCASE.SETUP%TYPE;
      v_TEARDOWN UT_TESTCASE.TEARDOWN%TYPE;
      v_EXCEPTIONS UT_TESTCASE.EXCEPTIONS%TYPE;
      v_TEST_ID UT_TESTCASE.TEST_ID%TYPE;
      v_PREFIX UT_TESTCASE.PREFIX%TYPE;
      v_ASSERTION UT_TESTCASE.ASSERTION%TYPE;
      v_INLINE_ASSERTION_CALL UT_TESTCASE.INLINE_ASSERTION_CALL%TYPE;
      v_EXECUTIONS UT_TESTCASE.EXECUTIONS%TYPE;
      v_FAILURES UT_TESTCASE.FAILURES%TYPE;
      v_LAST_START UT_TESTCASE.LAST_START%TYPE;
      v_LAST_END UT_TESTCASE.LAST_END%TYPE;
      v_rowcount INTEGER;

      PROCEDURE showcount (str IN VARCHAR2 := NULL) IS
      BEGIN
         SELECT COUNT(*) INTO v_rowcount
           FROM UT_TESTCASE;

         DBMS_OUTPUT.PUT_LINE ('# of rows in table ' || str || ': ' || v_rowcount);
      END;
   BEGIN
      newset ('DEL: Delete Processing', '*');

      showcount ('before delete - individual fields');
      FOR rec IN te_ut_testcase.allbypky_cur
      LOOP
         EXIT WHEN te_ut_testcase.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);
         te_ut_testcase.del (
            rec.ID,
            v_rowcount);
      END LOOP;
      showcount ('after delete');

      ROLLBACK;

      showcount ('before delete - by record');
      FOR rec IN te_ut_testcase.allbypky_cur
      LOOP
         EXIT WHEN te_ut_testcase.allbypky_cur%ROWCOUNT > NVL (maxrows, 5);
            v_pky.id := rec.ID;
         te_ut_testcase.del (
            v_pky,
            v_rowcount);
      END LOOP;
      showcount ('after delete');

      ROLLBACK;

      IF norowset
      THEN
         showcount ('Delete "No Row"');
         te_ut_testcase.del (
            g_norow.ID,
            v_rowcount);
         DBMS_OUTPUT.PUT_LINE ('Number of "no rows" deleted:' || v_rowcount);
      END IF;

   END;

   PROCEDURE load
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('LOAD: Pre-loading not performed for this table.');
   END;

END te_ut_testcase_tst;
/
