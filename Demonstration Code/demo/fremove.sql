CREATE OR REPLACE PROCEDURE fremove (
   NAME_IN IN VARCHAR2
 , dir_in IN VARCHAR2
 , show_result_in IN BOOLEAN := FALSE
)
-- After moving my zip file to the archive,
-- delete it from the development directory.
IS
BEGIN
   UTL_FILE.fremove (LOCATION => dir_in, filename => NAME_IN);

   IF show_result_in
   THEN
      DBMS_OUTPUT.put_line (   'Successfully removed: '
                            || NAME_IN
                            || ' from '
                            || dir_in
                           );
   END IF;
EXCEPTION
   -- If you call FREMOVE, you should check explicitly
   -- for deletion failures.
   WHEN UTL_FILE.delete_failed
   THEN
      IF show_result_in
      THEN
         DBMS_OUTPUT.put_line (   'Error attempting to remove: '
                               || NAME_IN
                               || ' from '
                               || dir_in
                              );
      END IF;

      /* Don't forget to re-raise the exception!
         Lysaker / Oslo Oct 2007 */
      RAISE;

   -- If file is not found, then a different error is raised
   WHEN UTL_FILE.invalid_operation
   THEN
      IF show_result_in
      THEN
         DBMS_OUTPUT.put_line (   'Unable to find and remove: '
                               || NAME_IN
                               || ' from '
                               || dir_in
                              );
      END IF;
      /* Don't forget to re-raise the exception!
         Lysaker / Oslo Oct 2007 */
      RAISE;
END;
/
