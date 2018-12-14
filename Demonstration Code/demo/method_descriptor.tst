CREATE OR REPLACE TYPE method_descriptor_test_t
AS
   OBJECT(
           name VARCHAR2( 100 ),
           food_group VARCHAR2( 100 ),
           grown_in VARCHAR2( 100 ),
           MEMBER FUNCTION price
              RETURN number,
           STATIC PROCEDURE healthy_reminder( hey_you_in IN CHAR ),
           CONSTRUCTOR FUNCTION method_descriptor_test_t(
                                                          SELF IN OUT method_descriptor_test_t,
                                                          NAME IN VARCHAR2
           )
              RETURN SELF AS RESULT
   )
   NOT FINAL;
/

DECLARE
   /* Overall status of test */
   g_success BOOLEAN DEFAULT TRUE ;

   -- General reporting utility
   PROCEDURE report_failure(
                             description_in IN VARCHAR2
   )
   IS
   BEGIN
      g_success   := FALSE;
      DBMS_OUTPUT.put_line( '   Failure on test "' || description_in || '"' );
   END report_failure;

   PROCEDURE run_test_case(
                            test_case_name_in IN VARCHAR2,
                            type_owner_in IN all_types.owner%TYPE,
                            type_name_in IN all_types.type_name%TYPE,
                            method_name_in IN all_type_methods.method_name%TYPE,
                            method_no_in IN all_type_methods.method_no%TYPE,
                            expected_value_in IN VARCHAR2,
                            test_type_in IN VARCHAR2
   -- 'EQ' or 'ISNULL' or 'ISNOTNULL'
   )
   IS
      l_success BOOLEAN DEFAULT TRUE ;
      -- Variable for function return value
      l_METHOD_DESCRIPTOR varchar2( 100 );
   BEGIN
      l_METHOD_DESCRIPTOR :=
         METHOD_DESCRIPTOR(
                            type_owner_in,
                            type_name_in,
                            method_name_in,
                            method_no_in
         );

      -- Check value returned by function against the expected value.
-- If they don't match, report the failure, providing a test case name.
      IF test_type_in = 'EQ'
      THEN
         IF l_METHOD_DESCRIPTOR != expected_value_in OR l_METHOD_DESCRIPTOR IS NULL
         THEN
            l_success   := FALSE;
            report_failure( test_case_name_in );
         END IF;
      ELSIF test_type_in = 'ISNULL'
      THEN
         IF l_METHOD_DESCRIPTOR IS NOT NULL
         THEN
            l_success   := FALSE;
            report_failure( test_case_name_in );
         END IF;
      ELSIF test_type_in = 'ISNOTNULL'
      THEN
         IF l_METHOD_DESCRIPTOR IS NULL
         THEN
            l_success   := FALSE;
            report_failure( test_case_name_in );
         END IF;
      END IF;

      IF l_success
      THEN
         DBMS_OUTPUT.put_line(   '   Success on test case "'
                              || test_case_name_in
                              || '"');
      END IF;
   END run_test_case;
BEGIN
   DBMS_OUTPUT.put_line( 'Testing METHOD_DESCRIPTOR' );

   -- Make a copy for each test case, change the arguments to match.
   run_test_case(
                  test_case_name_in => 'Check constructor',
                  type_owner_in => USER,
                  type_name_in => 'METHOD_DESCRIPTOR_TEST_T',
                  method_name_in => 'METHOD_DESCRIPTOR_TEST_T',
                  method_no_in => 3,
                  expected_value_in => 'CONSTRUCTOR',
                  test_type_in => 'EQ'
   );
   run_test_case(
                  test_case_name_in => 'Check static',
                  type_owner_in => USER,
                  type_name_in => 'METHOD_DESCRIPTOR_TEST_T',
                  method_name_in => 'HEALTHY_REMINDER',
                  method_no_in => 2,
                  expected_value_in => 'STATIC',
                  test_type_in => 'EQ'
   );
   run_test_case(
                  test_case_name_in => 'Check member',
                  type_owner_in => USER,
                  type_name_in => 'METHOD_DESCRIPTOR_TEST_T',
                  method_name_in => 'PRICE',
                  method_no_in => 1,
                  expected_value_in => 'MEMBER',
                  test_type_in => 'EQ'
   );


   IF g_success
   THEN
      DBMS_OUTPUT.put_line('Overall test status for METHOD_DESCRIPTOR: SUCCESS');
   ELSE
      DBMS_OUTPUT.put_line('Overall test status for METHOD_DESCRIPTOR: FAILURE');
   END IF;
END;
/
