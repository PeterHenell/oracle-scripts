CREATE TABLE real_log (n INTEGER, m INTEGER)
/

DECLARE
   -- Example of anchor over DB Link
   -- TYPE namelist_t IS TABLE OF employee.last_name@oracle92%type;
   TYPE namelist_t IS TABLE OF VARCHAR2 (5000);

   -- employee.last_name%TYPE;
   enames_with_errors namelist_t
         := namelist_t ('ABC'
                      , 'DEF'
                      , NULL
                      , 'LITTLE'
                      , RPAD ('BIGBIGGERBIGGEST', 3000, 'ABC')
                      , 'SMITHIE'
                       ) ;
BEGIN
   FORALL indx IN enames_with_errors.FIRST .. enames_with_errors.LAST
   SAVE EXCEPTIONS
      UPDATE employees
         SET first_name = enames_with_errors (indx);

   ROLLBACK;
EXCEPTION
   WHEN errpkg.bulk_errors
   THEN
       FORALL indx IN 1 .. sql%BULK_EXCEPTIONS.COUNT
         INSERT INTO real_log
             VALUES (
                        sql%BULK_EXCEPTIONS (indx).ERROR_INDEX
                      , sql%BULK_EXCEPTIONS (indx).ERROR_CODE
                    );
END;