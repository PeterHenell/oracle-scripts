DECLARE
--
-- Simple unit test framework for check_string.is_number
-- Designed specifically for use with deterministic functions.
--
-- Top level block; global variable to determine if this test
-- succeeded for failed.
--
   g_success   BOOLEAN DEFAULT TRUE;

   -- Declare global variables
   PROCEDURE initialize
   IS
   -- Initialize data for the test
   BEGIN
      NULL;
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
   PROCEDURE t_is_number
   IS
      l_success     BOOLEAN DEFAULT TRUE;
      -- Variable for function return value
      l_is_number   BOOLEAN;

      PROCEDURE run_test_case (
         test_case_name_in   IN   VARCHAR2
        ,str_in              IN   VARCHAR2
        ,numeric_format_in   IN   VARCHAR2
        ,expected_value_in   IN   BOOLEAN
        ,test_type_in        IN   VARCHAR2
      -- 'EQ' or 'ISNULL' or 'ISNOTNULL'
      )
      IS
      BEGIN
         l_is_number := check_string.is_number (str_in, numeric_format_in);

         -- Check value returned by function against the expected value.
         -- If they don't match, report the failure, providing a test case name.
         IF test_type_in = 'EQ'
         THEN
            IF l_is_number != expected_value_in OR l_is_number IS NULL
            THEN
               l_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNULL'
         THEN
            IF l_is_number IS NOT NULL
            THEN
               l_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNOTNULL'
         THEN
            IF l_is_number IS NULL
            THEN
               l_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         END IF;

         IF l_success
         THEN
            DBMS_OUTPUT.put_line (   '   Success on test case "'
                                  || test_case_name_in
                                  || '"'
                                 );
         END IF;
      END run_test_case;
   BEGIN
      DBMS_OUTPUT.put_line ('Testing check_string.is_number');
      -- Make a copy for each test case, change the arguments to match.
      run_test_case
                   (test_case_name_in      => 'No format mask, simple integer'
                   ,str_in                 => '1'
                   ,numeric_format_in      => NULL
                   ,expected_value_in      => TRUE
                   ,test_type_in           => 'EQ'
                   );
      run_test_case (test_case_name_in      => 'NULL string'
                    ,str_in                 => ''
                    ,numeric_format_in      => NULL
                    ,expected_value_in      => TRUE
                    ,test_type_in           => 'ISNULL'
                    );
      run_test_case (test_case_name_in      => 'No format mask, simple number'
                    ,str_in                 => '1.5'
                    ,numeric_format_in      => NULL
                    ,expected_value_in      => TRUE
                    ,test_type_in           => 'EQ'
                    );
      run_test_case (test_case_name_in      => 'No format mask, invalid number'
                    ,str_in                 => '1.5w'
                    ,numeric_format_in      => NULL
                    ,expected_value_in      => FALSE
                    ,test_type_in           => 'EQ'
                    );
      run_test_case
                 (test_case_name_in      => 'Dollar value without format model'
                 ,str_in                 => '$100.50'
                 ,numeric_format_in      => NULL
                 ,expected_value_in      => FALSE
                 ,test_type_in           => 'EQ'
                 );
      run_test_case (test_case_name_in      => 'Dollar value with format model'
                    ,str_in                 => '$100.50'
                    ,numeric_format_in      => '$9999999.99'
                    ,expected_value_in      => TRUE
                    ,test_type_in           => 'EQ'
                    );
      run_test_case
            (test_case_name_in      => 'Trailing negative sign no format model'
            ,str_in                 => '100-'
            ,numeric_format_in      => NULL
            ,expected_value_in      => FALSE
            ,test_type_in           => 'EQ'
            );
      run_test_case
          (test_case_name_in      => 'Trailing negative sign with format model'
          ,str_in                 => '100-'
          ,numeric_format_in      => '9999MI'
          ,expected_value_in      => TRUE
          ,test_type_in           => 'EQ'
          );

      IF l_success
      THEN
         DBMS_OUTPUT.put_line ('   Success!');
      END IF;

      DBMS_OUTPUT.put_line ('');
   END t_is_number;
BEGIN
   initialize;
   t_is_number;

   IF g_success
   THEN
      DBMS_OUTPUT.put_line
                ('Overall test status for check_string.is_number: SUCCESS');
   ELSE
      DBMS_OUTPUT.put_line
                ('Overall test status for check_string.is_number: FAILURE');
   END IF;
END;
/