CREATE OR REPLACE PACKAGE ut_between_string
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;
 
   -- For each program to test...
   PROCEDURE ut_between_string;
END ut_between_string;
/
