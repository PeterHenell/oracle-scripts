DECLARE
/*
   Simple unit test framework for IS_SUBSET.

   Designed to work best/most easily with deterministic programs:
      Procedures and functions whose results are determined
      solely by the values of their IN arguments.

   Original author: Steven Feuerstein, www.Qnxo.com

   Qnxo Script ID: {324F6E8F-800B-40A0-AAC5-7E15700A8223}

   You are granted permission to use this code if it was generated
   by a licensed user of Qnxo.

   >> Generated on September 15, 2005 12:03:08 in schema QNXO_REPOSITORY
*/ --Global variable to determine if this test succeeded for failed.
   g_success               BOOLEAN            DEFAULT TRUE;
   --
   g_collection_same1      DBMS_SQL.varchar2s;
   g_collection_same2      DBMS_SQL.varchar2s;
   g_collection_subsame1   DBMS_SQL.varchar2s;
   g_collection_subdiff1   DBMS_SQL.varchar2s;
   g_collection_subdiff2   DBMS_SQL.varchar2s;
   g_empty_collection1     DBMS_SQL.varchar2s;
   g_empty_collection2     DBMS_SQL.varchar2s;

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
      g_collection_subsame1 (100) := 'ABC';
      --
      g_collection_subdiff1 (-99) := 'ABC';
      g_collection_subdiff1 (44) := 'DEF';
      g_collection_subdiff1 (77) := 'QRS';
      --
      g_collection_subdiff2 (-99) := 'ABC';
      g_collection_subdiff2 (44) := 'DEF';
      g_collection_subdiff2 (77) := 'HIJ';
      g_collection_subdiff2 (1000) := 'HIJLMN';
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
   PROCEDURE t_is_subset
   IS
      l_t_success   BOOLEAN DEFAULT TRUE;
      -- Variable for function return value
      l_is_subset   BOOLEAN;

      PROCEDURE run_test_case (
         test_case_name_in   IN   VARCHAR2
       , superset_in         IN   DBMS_SQL.varchar2s
       , subset_in           IN   DBMS_SQL.varchar2s
       , expected_value_in   IN   BOOLEAN
       , test_type_in        IN   VARCHAR2   -- 'EQ' or 'ISNULL' or 'ISNOTNULL'
      )
      IS
         l_tc_success   BOOLEAN DEFAULT TRUE;
      BEGIN
         l_is_subset :=
               is_subset (superset_in      => superset_in
                        , subset_in        => subset_in);

         -- Check value returned by function against the expected value.
         -- If they don't match, report the failure, providing a test case name.
         IF test_type_in = 'EQ'
         THEN
            IF l_is_subset != expected_value_in OR l_is_subset IS NULL
            THEN
               l_tc_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNULL'
         THEN
            IF l_is_subset IS NOT NULL
            THEN
               l_tc_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNOTNULL'
         THEN
            IF l_is_subset IS NULL
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
      DBMS_OUTPUT.put_line ('Testing IS_SUBSET');
      -- Make a copy for each test case, change the arguments to match.
      run_test_case
         (test_case_name_in      => 'Both collections the same'
        , superset_in            => g_collection_same1
        , subset_in              => g_collection_same2
        , expected_value_in      => TRUE
        , test_type_in           => 'EQ'   
         );
      run_test_case
          (test_case_name_in      => 'Both collections the same, reverse order'
         , superset_in            => g_collection_same2
         , subset_in              => g_collection_same1
         , expected_value_in      => TRUE
         , test_type_in           => 'EQ'   
          );
      run_test_case
          (test_case_name_in      => 'Subset is contained in superset'
         , superset_in            => g_collection_same1
         , subset_in              => g_collection_subsame1
         , expected_value_in      => TRUE
         , test_type_in           => 'EQ'   
          );
      run_test_case
          (test_case_name_in      => 'Subset is not contained in superset - different values'
         , superset_in            => g_collection_same1
         , subset_in              => g_collection_subdiff1
         , expected_value_in      => FALSE
         , test_type_in           => 'EQ'   
          );
      run_test_case
          (test_case_name_in      => 'Subset is not contained in superset - has more values'
         , superset_in            => g_collection_same1
         , subset_in              => g_collection_subdiff2
         , expected_value_in      => FALSE
         , test_type_in           => 'EQ'   
          );		  
      run_test_case
          (test_case_name_in      => 'Both collections empty'
         , superset_in            => g_empty_collection1
         , subset_in              => g_empty_collection2
         , expected_value_in      => FALSE
         , test_type_in           => 'EQ'   
          );
      run_test_case
          (test_case_name_in      => 'Subset is empty'
         , superset_in            => g_collection_same1
         , subset_in              => g_empty_collection2
         , expected_value_in      => FALSE
         , test_type_in           => 'EQ'   
          );
      run_test_case
          (test_case_name_in      => 'Superset is empty'
         , superset_in            => g_empty_collection1
         , subset_in              => g_collection_same2
         , expected_value_in      => FALSE
         , test_type_in           => 'EQ'   
          );

      IF l_t_success
      THEN
         DBMS_OUTPUT.put_line ('   Success!');
      END IF;

      DBMS_OUTPUT.put_line ('');
   END t_is_subset;
BEGIN
   initialize;
   t_is_subset;

   IF g_success
   THEN
      DBMS_OUTPUT.put_line ('Overall test status for IS_SUBSET: SUCCESS');
   ELSE
      DBMS_OUTPUT.put_line ('Overall test status for IS_SUBSET: FAILURE');
   END IF;
END;
/
