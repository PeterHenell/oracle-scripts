CREATE OR REPLACE PACKAGE BODY ut_str
IS
   PROCEDURE ut_setup
   IS
   BEGIN
      NULL;
   END;
   
   PROCEDURE ut_teardown
   IS
   BEGIN
      NULL;
   END;
   -- For each program to test...
   PROCEDURE ut_BETWN
   IS
      -- Verify and complete data types.
      against_this VARCHAR2(2000);
      check_this VARCHAR2(2000);
   BEGIN
      
      -- Define "control" operation
       
      against_this := NULL;
       
      -- Execute test code
       
      check_this := 
      STR.BETWN (
         STRING_IN => ''
         ,
         START_IN => ''
         ,
         END_IN => ''
       );
       
      -- Assert success
       
      -- Compare the two values.
      utAssert.eq (
         'Test of BETWN',
         check_this,
         against_this
         );
      
      -- End of test
   END ut_BETWN;

END ut_str;
/
