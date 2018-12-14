/* 

   Corrected from bad_exception_section.sql
   
   Relying on the code found in errpkg.pkg and errnums.pkg 

*/

BEGIN
   NULL;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      errpkg.
       record_and_continue (SQLCODE, ' No company for id ' || TO_CHAR (v_id));
   WHEN DUP_VAL_ON_INDEX
   THEN
      errpkg.record_and_stop (errnums.en_duplicate_company);
   WHEN OTHERS
   THEN
      errpkg.record_and_stop;
END;
/