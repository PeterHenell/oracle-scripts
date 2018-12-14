CREATE OR REPLACE PROCEDURE bulk_exceptions (whr_in IN VARCHAR2 := NULL)
IS
   TYPE numlist_t IS TABLE OF NUMBER;

   TYPE namelist_t IS TABLE OF VARCHAR2 (100);

   employee_ids   numlist_t := numlist_t (7505, 7521, 7564, 7600, 7676);

   enames_with_errors namelist_t
         := namelist_t ('ABC'
                      , NULL
                      , 'LITTLE'
                      , RPAD ('BIGBIGGERBIGGEST', 50, 'ABC')
                      , 'SMITHIE'
                       );

   bulk_errors EXCEPTION;
   PRAGMA EXCEPTION_INIT (bulk_errors, -24381);
BEGIN
   FORALL indx IN enames_with_errors.FIRST .. enames_with_errors.LAST
   SAVE EXCEPTIONS
      EXECUTE IMMEDIATE 'UPDATE employee 
		     SET last_name = :new_name 
			WHERE employee_id = :empid'
         USING enames_with_errors (indx), employee_ids (indx);
EXCEPTION
   WHEN bulk_errors
   THEN
      -- Grand Rapids 10/2002
      DBMS_OUTPUT.put_line ('Updated ' || SQL%ROWCOUNT || ' rows.');

      FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
      LOOP
         DBMS_OUTPUT.put_line(   'Error '
                              || indx
                              || ' occurred during '
                              || 'iteration '
                              || SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX
                              || ' updating name to '
                              || enames_with_errors (
                                    SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX
                                 ));
         DBMS_OUTPUT.put_line('Oracle error is '
                              || SQLERRM(-1
                                         * SQL%BULK_EXCEPTIONS (indx).ERROR_CODE));
      END LOOP;
END;
/