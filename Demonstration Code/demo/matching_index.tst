DECLARE
/*
   Simple unit test framework for MATCHING_INDEX.

   Designed specifically for use with deterministic functions.

   Original author: Steven Feuerstein, www.Qnxo.com

   Qnxo Script ID: {324F6E8F-800B-40A0-AAC5-7E15700A8223}

   You are granted permission to use this code if it was generated
   by a licensed user of Qnxo.

   >> Generated on July      31, 2005 20:40:39 in schema QNXO_REPOSITORY

   Grid of test cases
*/
-- Top level block; global variable to determine if this test
-- succeeded for failed.
   g_success            BOOLEAN            DEFAULT TRUE;
   --
   g_collection         DBMS_SQL.varchar2s;
   g_empty_collection   DBMS_SQL.varchar2s;

   PROCEDURE initialize
   IS
   BEGIN
      g_collection (1) := 'ABC';
      g_collection (10) := 'DEF';
      g_collection (11) := NULL;
      g_collection (100) := '123';
   END initialize;

   -- General reporting utility
   PROCEDURE report_failure (description_in IN VARCHAR2)
   IS
   BEGIN
      g_success := FALSE;
      DBMS_OUTPUT.put_line ('   Failure on test "' || description_in || '"'
                           );
   END report_failure;

-- For each program, generate a local module to test that program.
-- These are then each called in the executable section of the main block.
   PROCEDURE t_matching_index
   IS
      l_t_success        BOOLEAN     DEFAULT TRUE;
      -- Variable for function return value
      l_matching_index   PLS_INTEGER;

      PROCEDURE run_test_case (
         test_case_name_in   IN   VARCHAR2
        ,collection_in            DBMS_SQL.varchar2s
        ,value_in                 VARCHAR2
        ,forward_in               BOOLEAN
        ,nulls_eq_in         IN   BOOLEAN 
        ,expected_value_in   IN   PLS_INTEGER
        ,test_type_in        IN   VARCHAR2
      -- 'EQ' or 'ISNULL' or 'ISNOTNULL'
      )
      IS
         l_tc_success   BOOLEAN DEFAULT TRUE;
      BEGIN
         l_matching_index :=
            matching_index (collection_in  => collection_in
                           ,value_in       => value_in
                           ,forward_in     => forward_in
						   ,nulls_eq_in    => nulls_eq_in
                           );

         -- Check value returned by function against the expected value.
         -- If they don't match, report the failure, providing a test case name.
         IF test_type_in = 'EQ'
         THEN
            IF l_matching_index != expected_value_in OR l_matching_index IS NULL
            THEN
               l_tc_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNULL'
         THEN
            IF l_matching_index IS NOT NULL
            THEN
               l_tc_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNOTNULL'
         THEN
            IF l_matching_index IS NULL
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
      DBMS_OUTPUT.put_line ('Testing MATCHING_INDEX');
      -- Make a copy for each test case, change the arguments to match.
      run_test_case (test_case_name_in      => 'Collection is empty'
                    ,collection_in          => g_empty_collection
                    ,value_in               => 'VALUE'
                    ,forward_in             => TRUE
                    ,nulls_eq_in            => TRUE
                    ,expected_value_in      => NULL
                    ,test_type_in           => 'ISNULL'
                    );
      run_test_case
           (test_case_name_in      => 'Match found at first row, going forward'
           ,collection_in          => g_collection
           ,value_in               => 'ABC'
           ,forward_in             => TRUE
           ,nulls_eq_in            => TRUE
           ,expected_value_in      => 1
           ,test_type_in           => 'EQ'
           );
      run_test_case
            (test_case_name_in      => 'Match found at last row, going forward'
            ,collection_in          => g_collection
            ,value_in               => '123'
            ,forward_in             => true
            ,nulls_eq_in            => TRUE
            ,expected_value_in      => 100
            ,test_type_in           => 'EQ'
            );
      run_test_case
           (test_case_name_in      => 'Match found at first row, going backward'
           ,collection_in          => g_collection
           ,value_in               => 'ABC'
           ,forward_in             => false
           ,nulls_eq_in            => TRUE
           ,expected_value_in      => 1
           ,test_type_in           => 'EQ'
           );
      run_test_case
            (test_case_name_in      => 'Match found at last row, going backward'
            ,collection_in          => g_collection
            ,value_in               => '123'
            ,forward_in             => false
            ,nulls_eq_in            => TRUE
            ,expected_value_in      => 100
            ,test_type_in           => 'EQ'
            );			
      run_test_case
          (test_case_name_in      => 'Match found in collection, going forward'
          ,collection_in          => g_collection
          ,value_in               => 'DEF'
          ,forward_in             => TRUE
          ,nulls_eq_in            => TRUE
          ,expected_value_in      => 10
          ,test_type_in           => 'EQ'
          );
      run_test_case
         (test_case_name_in      => 'Match found in collection, going backward'
         ,collection_in          => g_collection
         ,value_in               => 'DEF'
         ,forward_in             => FALSE
         ,nulls_eq_in            => TRUE
         ,expected_value_in      => 10
         ,test_type_in           => 'EQ' 
         );
      run_test_case
         (test_case_name_in      => 'Value is not in the non-empty collection, going forward'
         ,collection_in          => g_collection
         ,value_in               => 'QRS'
         ,forward_in             => TRUE
         ,nulls_eq_in            => TRUE
         ,expected_value_in      => NULL
         ,test_type_in           => 'ISNULL'
         );
      run_test_case
         (test_case_name_in      => 'Value is not in the non-empty collection, going backward'
         ,collection_in          => g_collection
         ,value_in               => 'QRS'
         ,forward_in             => FALSE
         ,nulls_eq_in            => TRUE
         ,expected_value_in      => NULL
         ,test_type_in           => 'ISNULL'
         );
      run_test_case
         (test_case_name_in      => 'Search for NULL with nulls EQ set to TRUE'
         ,collection_in          => g_collection
         ,value_in               => NULL
         ,forward_in             => TRUE
         ,nulls_eq_in            => TRUE
         ,expected_value_in      => 11
         ,test_type_in           => 'EQ'
         );
      run_test_case
         (test_case_name_in      => 'Search for NULL with nulls EQ set to FALSE'
         ,collection_in          => g_collection
         ,value_in               => NULL
         ,forward_in             => TRUE
         ,nulls_eq_in            => FALSE
         ,expected_value_in      => NULL
         ,test_type_in           => 'ISNULL'
         );

      IF l_t_success
      THEN
         DBMS_OUTPUT.put_line ('   Success!');
      END IF;

      DBMS_OUTPUT.put_line ('');
   END t_matching_index;
BEGIN
   initialize;
   t_matching_index;

   IF g_success
   THEN
      DBMS_OUTPUT.put_line
                        ('Overall test status for MATCHING_INDEX: SUCCESS');
   ELSE
      DBMS_OUTPUT.put_line
                        ('Overall test status for MATCHING_INDEX: FAILURE');
   END IF;
END;
/