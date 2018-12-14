DECLARE
/*
   Simple unit test framework for COLLECTIONS_EQUAL.

   Designed specifically for use with deterministic functions.

   Original author: Steven Feuerstein, www.Qnxo.com

   Qnxo Script ID: {324F6E8F-800B-40A0-AAC5-7E15700A8223}

   You are granted permission to use this code if it was generated
   by a licensed user of Qnxo.

   >> Generated on July      31, 2005 21:38:15 in schema QNXO_REPOSITORY
*/ --Global variable to determine if this test succeeded for failed.
   g_success                     BOOLEAN            DEFAULT TRUE;
   --
   g_collection_same1            DBMS_SQL.varchar2s;
   g_collection_same2            DBMS_SQL.varchar2s;
   g_collection_same_data2       DBMS_SQL.varchar2s;
   g_collection_diff             DBMS_SQL.varchar2s;
   g_collection_same_null1       DBMS_SQL.varchar2s;
   g_collection_same_null2       DBMS_SQL.varchar2s;
   g_collection_multiple_nulls   DBMS_SQL.varchar2s;
   g_empty_collection1           DBMS_SQL.varchar2s;
   g_empty_collection2           DBMS_SQL.varchar2s;

   -- Insert code here to setup for testing.
   PROCEDURE initialize
   IS
   BEGIN
      g_collection_same1 (100) := 'ABC';
      g_collection_same1 (1000) := 'DEF';
      g_collection_same1 (10000) := 'HIJ';
      --
      g_collection_same2 (100) := 'ABC';
      g_collection_same2 (1000) := 'DEF';
      g_collection_same2 (10000) := 'HIJ';
      --
      g_collection_diff (100) := 'ABC';
      g_collection_diff (200) := 'ABC';
      --
      g_collection_same_data2 (-99) := 'ABC';
      g_collection_same_data2 (44) := 'DEF';
      g_collection_same_data2 (77) := 'HIJ';
      --
      g_collection_same_null1 (100) := NULL;
      g_collection_same_null1 (1000) := 'DEF';
      g_collection_same_null1 (10000) := 'HIJ';
      --
      g_collection_same_null2 (100) := NULL;
      g_collection_same_null2 (1000) := 'DEF';
      g_collection_same_null2 (10000) := 'HIJ';
      --
      g_collection_multiple_nulls (100) := NULL;
      g_collection_multiple_nulls (1000) := NULL;
      g_collection_multiple_nulls (10000) := 'HIJ';
   END initialize;

   -- General reporting utility
   PROCEDURE report_failure (description_in IN VARCHAR2)
   IS
   BEGIN
      g_success := FALSE;
      DBMS_OUTPUT.put_line ('   Failure on test "' || description_in || '"');
   END report_failure;

-- For each program, generate a local module to test that program.
-- These are then each called in the executable section of the main block.
   PROCEDURE t_collections_equal
   IS
      l_t_success           BOOLEAN DEFAULT TRUE;
      -- Variable for function return value
      l_collections_equal   BOOLEAN;

      PROCEDURE run_test_case (
         test_case_name_in   IN   VARCHAR2
       , collection1_in      IN   DBMS_SQL.varchar2s
       , collection2_in      IN   DBMS_SQL.varchar2s
       , match_indexes_in    IN   BOOLEAN
       , both_null_true_in   IN   BOOLEAN
       , expected_value_in   IN   BOOLEAN
       , test_type_in        IN   VARCHAR2
      -- 'EQ' or 'ISNULL' or 'ISNOTNULL'
      )
      IS
         l_tc_success   BOOLEAN DEFAULT TRUE;
      BEGIN
         l_collections_equal :=
            collections_equal (collection1_in         => collection1_in
                             , collection2_in         => collection2_in
                             , match_indexes_in       => match_indexes_in
                             , both_null_true_in      => both_null_true_in
                              );

         -- Check value returned by function against the expected value.
         -- If they don't match, report the failure, providing a test case name.
         IF test_type_in = 'EQ'
         THEN
            IF    l_collections_equal != expected_value_in
               OR l_collections_equal IS NULL
            THEN
               l_tc_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNULL'
         THEN
            IF l_collections_equal IS NOT NULL
            THEN
               l_tc_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNOTNULL'
         THEN
            IF l_collections_equal IS NULL
            THEN
               l_tc_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         END IF;

         IF NOT l_tc_success
         THEN
            l_t_success := FALSE;
         ELSE
            DBMS_OUTPUT.put_line (   '   Success on test case "'
                                  || test_case_name_in
                                  || '"'
                                 );
         END IF;
      END run_test_case;
   BEGIN
      DBMS_OUTPUT.put_line ('Testing COLLECTIONS_EQUAL');
      -- Make a copy for each test case, change the arguments to match.
      run_test_case
         (test_case_name_in      => 'Two collections identical, including row numbers'
        , collection1_in         => g_collection_same1
        , collection2_in         => g_collection_same2
        , match_indexes_in       => TRUE
        , both_null_true_in      => TRUE
        , expected_value_in      => TRUE
        , test_type_in           => 'EQ'
         );
      run_test_case
         (test_case_name_in      => 'Two collections identical, except for row numbers'
        , collection1_in         => g_collection_same2
        , collection2_in         => g_collection_same_data2
        , match_indexes_in       => FALSE
        , both_null_true_in      => TRUE
        , expected_value_in      => TRUE
        , test_type_in           => 'EQ'
         );
      run_test_case
         (test_case_name_in      => 'Two collections identical, except for row numbers, required'
        , collection1_in         => g_collection_same2
        , collection2_in         => g_collection_same_data2
        , match_indexes_in       => TRUE
        , both_null_true_in      => TRUE
        , expected_value_in      => FALSE
        , test_type_in           => 'EQ'
         );
      run_test_case (test_case_name_in      => 'Two collections different'
                   , collection1_in         => g_collection_same1
                   , collection2_in         => g_collection_diff
                   , match_indexes_in       => TRUE
                   , both_null_true_in      => TRUE
                   , expected_value_in      => FALSE
                   , test_type_in           => 'EQ'
                    );
      run_test_case (test_case_name_in      => 'Both empty, both null set to true'
                   , collection1_in         => g_empty_collection1
                   , collection2_in         => g_empty_collection2
                   , match_indexes_in       => TRUE
                   , both_null_true_in      => TRUE
                   , expected_value_in      => TRUE
                   , test_type_in           => 'EQ'
                    );
      run_test_case
                   (test_case_name_in      => 'Both empty, both null set to false'
                  , collection1_in         => g_empty_collection1
                  , collection2_in         => g_empty_collection2
                  , match_indexes_in       => TRUE
                  , both_null_true_in      => FALSE
                  , expected_value_in      => FALSE
                  , test_type_in           => 'EQ'
                   );
      run_test_case
         (test_case_name_in      => 'One collecton empty, one not, both null set to false'
        , collection1_in         => g_collection_same1
        , collection2_in         => g_empty_collection2
        , match_indexes_in       => TRUE
        , both_null_true_in      => FALSE
        , expected_value_in      => FALSE
        , test_type_in           => 'EQ'
         );
      run_test_case
         (test_case_name_in      => 'Collections with NULLs in same location, both null TRUE'
        , collection1_in         => g_collection_same_null1
        , collection2_in         => g_collection_same_null2
        , match_indexes_in       => TRUE
        , both_null_true_in      => TRUE
        , expected_value_in      => TRUE
        , test_type_in           => 'EQ'
         );
      run_test_case
         (test_case_name_in      => 'Collections with NULLs in same location, both null FALSE'
        , collection1_in         => g_collection_same_null1
        , collection2_in         => g_collection_same_null2
        , match_indexes_in       => TRUE
        , both_null_true_in      => FALSE
        , expected_value_in      => FALSE
        , test_type_in           => 'EQ'
         );
      run_test_case
         (test_case_name_in      => 'Collections with NULLs, one multiples, both null TRUE'
        , collection1_in         => g_collection_same_null1
        , collection2_in         => g_collection_multiple_nulls
        , match_indexes_in       => TRUE
        , both_null_true_in      => TRUE
        , expected_value_in      => FALSE
        , test_type_in           => 'EQ'
         );

      IF l_t_success
      THEN
         DBMS_OUTPUT.put_line ('   Success!');
      END IF;

      DBMS_OUTPUT.put_line ('');
   END t_collections_equal;
BEGIN
   initialize;
   t_collections_equal;

   IF g_success
   THEN
      DBMS_OUTPUT.put_line
                        ('Overall test status for COLLECTIONS_EQUAL: SUCCESS');
   ELSE
      DBMS_OUTPUT.put_line
                        ('Overall test status for COLLECTIONS_EQUAL: FAILURE');
   END IF;
END;
/
