CREATE OR REPLACE PACKAGE ut_str
IS
   PROCEDURE ut_setup;
   PROCEDURE ut_teardown;
 
   -- For each program to test...
   PROCEDURE ut_BETWN;
END ut_str;
/
