/*
Here is a little demo script.
*/
DECLARE
   PROCEDURE bpl (val IN BOOLEAN)
   IS
   BEGIN
      IF val
      THEN
         DBMS_OUTPUT.put_line ('TRUE');
      ELSIF NOT val
      THEN
         DBMS_OUTPUT.put_line ('FALSE');
      ELSE
         DBMS_OUTPUT.put_line ('NULL');
      END IF;
   END bpl;
BEGIN
   bpl (files_are_equal ('files_are_equal.tst', 'TEMP', 'files_are_equal.tst', 'TEMP'));
   bpl (files_are_equal ('files_are_equal.tst', 'TEMP', 'eqtables.tst', 'TEMP'));
   bpl (files_are_equal ('files_are_equal.tst', 'TEMP', 'nonexistent.file', 'TEMP'));
END;
/
/*
And now we will set up a sequence of loads of each of the versions of the code, 
followed by execution of the Code Tester test, and display of results.

In other words, I assume that the test definition has already been imported
into Code Tester, and a test package generated.
*/
@utl_file_constants.pkg
@plsql_limits.pks
@q##files_are_equal.sp

SET SERVEROUTPUT ON FORMAT WRAPPED
SET LINESIZE 200

SPOOL eqfiles_test.log

@eqfiles_before_ref.sf
CALL test_files_are_equal ('eqfiles_before_ref');

@eqfiles_refactor_names.sf
CALL test_files_are_equal ('eqfiles_refactor_names');

@eqfiles_helper_programs.sf
CALL test_files_are_equal ('eqfiles_helper_programs');

@eqfiles_no_literals.sf
CALL test_files_are_equal ('eqfiles_no_literals');

@eqfiles_real_comparison.sf
CALL test_files_are_equal ('eqfiles_real_comparison');

@eqfiles_bullet_proof.sf
CALL test_files_are_equal ('eqfiles_bullet_proof');

@eqfiles_with_qem.sf
CALL test_files_are_equal ('eqfiles_with_qem');

@eqfiles_moving_parts.sf
CALL test_files_are_equal ('eqfiles_moving_parts');

SPOOL OFF
