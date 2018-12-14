DECLARE
--
-- Simple unit test framework for <program_name>
-- Designed specifically for use with deterministic functions.
--
-- Top level block; global variable to determine if this test
-- succeeded for failed.
--
   g_success            BOOLEAN            DEFAULT TRUE;

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
   PROCEDURE t_<program_name>
   IS
      l_success         BOOLEAN DEFAULT TRUE;
	  
      -- Variable for function return value
      l_<program_name>   <function_return_datatype>;

      PROCEDURE run_test_case (
         test_case_name_in   IN   VARCHAR2
		 <program_argument_list>
        ,expected_value_in   IN   BOOLEAN
        ,test_type_in        IN   VARCHAR2
      -- 'EQ' or 'ISNULL' or 'ISNOTNULL'
      )
      IS
      BEGIN
         l_<program_name> :=
            <program_name> (
			   <program_argument_list>
			);

         -- Check value returned by function against the expected value.
         -- If they don't match, report the failure, providing a test case name.
         IF test_type_in = 'EQ'
         THEN
            IF    l_<program_name> != expected_value_in
               OR l_<program_name> IS NULL
            THEN
               l_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNULL'
         THEN
            IF l_<program_name> IS NOT NULL
            THEN
               l_success := FALSE;
               report_failure (test_case_name_in);
            END IF;
         ELSIF test_type_in = 'ISNOTNULL'
         THEN
            IF l_<program_name> IS NULL
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
      DBMS_OUTPUT.put_line ('Testing <program_name>');
	  
      -- Make a copy for each test case, change the arguments to match.
      run_test_case
         (test_case_name_in      => '<testcase_description>'
         <program_argument_list>
         ,expected_value_in      => EXPECTED_VALUE
         ,test_type_in           => TEST_TYPE -- 'EQ', 'ISNULL' or 'ISNOTNULL'		 
         );

      IF l_success
      THEN
         DBMS_OUTPUT.put_line ('   Success!');
      END IF;

      DBMS_OUTPUT.put_line ('');
   END t_<program_name>;
BEGIN
   initialize;
   t_<program_name>;

   IF g_success
   THEN
      DBMS_OUTPUT.put_line
                         ('Overall test status for <program_name>: SUCCESS');
   ELSE
      DBMS_OUTPUT.put_line
                         ('Overall test status for <program_name>: FAILURE');
   END IF;
END;
/