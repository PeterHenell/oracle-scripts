-- Assertion package
@qu_assert.pks
SHO ERR

@qu_assert.pkb
SHO ERR

-- Source code
@dyn_placeholder.pks
SHO ERR
@dyn_placeholder.pkb
SHO ERR

-- Test code 
@ut_dyn_placeholder.pkg
SHO ERR

SET SERVEROUTPUT ON FORMAT WRAPPED SIZE 1000000

-- Run test
BEGIN
   ut_dyn_placeholder.run_all_tests;
END;
/


