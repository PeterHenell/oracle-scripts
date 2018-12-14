CREATE OR REPLACE PACKAGE BODY ut_altind
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
   PROCEDURE ut_LOADCACHE
   IS
   BEGIN
      
      -- Define "control" operation
       
       
      -- Execute test code
       
      ALTIND.LOADCACHE;
       
      -- Assert success
       
      utAssert.this (
         'Test of LOADCACHE',
         '<boolean expression>'
         );
      
      -- End of test
   END ut_LOADCACHE;

   PROCEDURE ut_NOTRC
   IS
   BEGIN
      
      -- Define "control" operation
       
       
      -- Execute test code
       
      ALTIND.NOTRC;
       
      -- Assert success
       
      utAssert.this (
         'Test of NOTRC',
         '<boolean expression>'
         );
      
      -- End of test
   END ut_NOTRC;

   PROCEDURE ut_ONEROW1
   IS
      -- Verify and complete data types.
      against_this RECORD;
      check_this RECORD;
   BEGIN
      
      -- Define "control" operation
       
      against_this := NULL;
       
      -- Execute test code
       
      check_this := 
      ALTIND.ONEROW (
         EMPLOYEE_ID => ''
         ,
         EMPLOYEE_ID_IN => ''
         ,
         LAST_NAME => ''
         ,
         FIRST_NAME => ''
         ,
         MIDDLE_INITIAL => ''
         ,
         JOB_ID => ''
         ,
         MANAGER_ID => ''
         ,
         HIRE_DATE => ''
         ,
         SALARY => ''
         ,
         COMMISSION => ''
         ,
         DEPARTMENT_ID => ''
         ,
         EMPNO => ''
         ,
         ENAME => ''
         ,
         CREATED_BY => ''
         ,
         CREATED_ON => ''
         ,
         CHANGED_BY => ''
         ,
         CHANGED_ON => ''
       );
       
      -- Assert success
       
      -- Compare the two values.
      utAssert.eq (
         'Test of ONEROW',
         check_this,
         against_this
         );
      
      -- End of test
   END ut_ONEROW1;

   PROCEDURE ut_ONEROW2
   IS
      -- Verify and complete data types.
      against_this RECORD;
      check_this RECORD;
   BEGIN
      
      -- Define "control" operation
       
      against_this := NULL;
       
      -- Execute test code
       
      check_this := 
      ALTIND.ONEROW (
         EMPLOYEE_ID => ''
         ,
         LAST_NAME_IN => ''
         ,
         EMPLOYEE_ID => ''
         ,
         LAST_NAME => ''
         ,
         LAST_NAME => ''
         ,
         USEHASH => ''
         ,
         FIRST_NAME => ''
         ,
         FIRST_NAME => ''
         ,
         REC => ''
         ,
         MIDDLE_INITIAL => ''
         ,
         MIDDLE_INITIAL => ''
         ,
         JOB_ID => ''
         ,
         JOB_ID => ''
         ,
         MANAGER_ID => ''
         ,
         MANAGER_ID => ''
         ,
         HIRE_DATE => ''
         ,
         HIRE_DATE => ''
         ,
         SALARY => ''
         ,
         SALARY => ''
         ,
         COMMISSION => ''
         ,
         COMMISSION => ''
         ,
         DEPARTMENT_ID => ''
         ,
         DEPARTMENT_ID => ''
         ,
         EMPNO => ''
         ,
         EMPNO => ''
         ,
         ENAME => ''
         ,
         ENAME => ''
         ,
         CREATED_BY => ''
         ,
         CREATED_BY => ''
         ,
         CREATED_ON => ''
         ,
         CREATED_ON => ''
         ,
         CHANGED_BY => ''
         ,
         CHANGED_BY => ''
         ,
         CHANGED_ON => ''
         ,
         CHANGED_ON => ''
       );
       
      -- Assert success
       
      -- Compare the two values.
      utAssert.eq (
         'Test of ONEROW',
         check_this,
         against_this
         );
      
      -- End of test
   END ut_ONEROW2;

   PROCEDURE ut_ONEROW_DBIND
   IS
      -- Verify and complete data types.
      against_this RECORD;
      check_this RECORD;
   BEGIN
      
      -- Define "control" operation
       
      against_this := NULL;
       
      -- Execute test code
       
      check_this := 
      ALTIND.ONEROW_DBIND (
         EMPLOYEE_ID => ''
         ,
         LAST_NAME_IN => ''
         ,
         LAST_NAME => ''
         ,
         FIRST_NAME => ''
         ,
         MIDDLE_INITIAL => ''
         ,
         JOB_ID => ''
         ,
         MANAGER_ID => ''
         ,
         HIRE_DATE => ''
         ,
         SALARY => ''
         ,
         COMMISSION => ''
         ,
         DEPARTMENT_ID => ''
         ,
         EMPNO => ''
         ,
         ENAME => ''
         ,
         CREATED_BY => ''
         ,
         CREATED_ON => ''
         ,
         CHANGED_BY => ''
         ,
         CHANGED_ON => ''
       );
       
      -- Assert success
       
      -- Compare the two values.
      utAssert.eq (
         'Test of ONEROW_DBIND',
         check_this,
         against_this
         );
      
      -- End of test
   END ut_ONEROW_DBIND;

   PROCEDURE ut_ONEROW_DBNOIND
   IS
      -- Verify and complete data types.
      against_this RECORD;
      check_this RECORD;
   BEGIN
      
      -- Define "control" operation
       
      against_this := NULL;
       
      -- Execute test code
       
      check_this := 
      ALTIND.ONEROW_DBNOIND (
         EMPLOYEE_ID => ''
         ,
         LAST_NAME_IN => ''
         ,
         LAST_NAME => ''
         ,
         FIRST_NAME => ''
         ,
         MIDDLE_INITIAL => ''
         ,
         JOB_ID => ''
         ,
         MANAGER_ID => ''
         ,
         HIRE_DATE => ''
         ,
         SALARY => ''
         ,
         COMMISSION => ''
         ,
         DEPARTMENT_ID => ''
         ,
         EMPNO => ''
         ,
         ENAME => ''
         ,
         CREATED_BY => ''
         ,
         CREATED_ON => ''
         ,
         CHANGED_BY => ''
         ,
         CHANGED_ON => ''
       );
       
      -- Assert success
       
      -- Compare the two values.
      utAssert.eq (
         'Test of ONEROW_DBNOIND',
         check_this,
         against_this
         );
      
      -- End of test
   END ut_ONEROW_DBNOIND;

   PROCEDURE ut_SHOWHASH
   IS
   BEGIN
      
      -- Define "control" operation
       
       
      -- Execute test code
       
      ALTIND.SHOWHASH;
       
      -- Assert success
       
      utAssert.this (
         'Test of SHOWHASH',
         '<boolean expression>'
         );
      
      -- End of test
   END ut_SHOWHASH;

   PROCEDURE ut_TRACING
   IS
      -- Verify and complete data types.
      against_this BOOLEAN;
      check_this BOOLEAN;
   BEGIN
      
      -- Define "control" operation
       
      against_this := NULL;
       
      -- Execute test code
       
      check_this := 
      ALTIND.TRACING;
       
      -- Assert success
       
      -- Compare the two values.
      utAssert.eq (
         'Test of TRACING',
         check_this,
         against_this
         );
      
      -- End of test
   END ut_TRACING;

   PROCEDURE ut_TRC
   IS
   BEGIN
      
      -- Define "control" operation
       
       
      -- Execute test code
       
      ALTIND.TRC (
         STRT_IN => ''
         ,
         MAXRANGE_IN => ''
       );
       
      -- Assert success
       
      utAssert.this (
         'Test of TRC',
         '<boolean expression>'
         );
      
      -- End of test
   END ut_TRC;

END ut_altind;
/
