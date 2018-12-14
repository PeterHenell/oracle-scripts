REM DROP TABLE employee2;
REM CREATE TABLE employee2 as SELECT * FROM employee2;

CREATE OR REPLACE PROCEDURE BULK_EXCEPTIONS
IS
   -- Example of anchor over DB Linnk
   -- TYPE namelist_t IS TABLE OF employee.last_name@oracle92%type;
   TYPE namelist_t IS TABLE OF VARCHAR2 ( 1000 );

   -- employee.last_name%TYPE;
   enames_with_errors namelist_t
      := namelist_t ( 'ABC'
                    , 'DEF'
                    , NULL
                    , 'LITTLE'
                    , RPAD ( 'BIGBIGGERBIGGEST', 250, 'ABC' )
                    , 'SMITHIE'
                    );
BEGIN
   enames_with_errors.DELETE ( 3 );
   FORALL indx IN enames_with_errors.FIRST 
   .. enames_with_errors.LAST SAVE EXCEPTIONS
      UPDATE employee2
         SET last_name = enames_with_errors ( indx );
EXCEPTION
   /* You really DON'T want to be writing code like this....
     WHEN OTHERS
      THEN
         IF SQLCODE = -24381 */
   WHEN errpkg.bulk_errors
   THEN
      DBMS_OUTPUT.put_line ( 'Updated ' || SQL%ROWCOUNT || ' rows.' );

      FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
      LOOP
         p.l (    'Error '
               || indx
               || ' occurred during '
               || 'iteration '
               || SQL%BULK_EXCEPTIONS ( indx ).ERROR_INDEX
               || ' updating name to '
               || enames_with_errors
                                  ( SQL%BULK_EXCEPTIONS ( indx ).ERROR_INDEX )
             );
         p.l (    'Oracle error is '
               || SQLERRM ( -1 * SQL%BULK_EXCEPTIONS ( indx ).ERROR_CODE )
             );
      END LOOP;
   WHEN OTHERS
   THEN
      p.l ( 'Updated ' || SQL%ROWCOUNT || ' rows.' );
      p.l ( DBMS_UTILITY.format_error_stack );
END;
/