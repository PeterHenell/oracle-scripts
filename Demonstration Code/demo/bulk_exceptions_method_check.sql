DECLARE
   failure_in_forall EXCEPTION;
   PRAGMA EXCEPTION_INIT ( failure_in_forall, -24381 );
      TYPE namelist_t IS TABLE OF VARCHAR2 (5000);

   enames_with_errors   namelist_t
      := namelist_t ('ABC'
                   , 'DEF'
                   , RPAD ('BIGBIGGERBIGGEST', 1000, 'ABC')
                   , 'LITTLE'
                   , RPAD ('BIGBIGGERBIGGEST', 3000, 'ABC')
                   , 'SMITHIE'
                    );
BEGIN
   FORALL indx IN 1 .. enames_with_errors.COUNT
   SAVE EXCEPTIONS
      UPDATE employees
         SET first_name = enames_with_errors (indx)--log errors reject limit unlimited
      ;
EXCEPTION
   WHEN failure_in_forall
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
      DBMS_OUTPUT.put_line ('Updated ' || SQL%ROWCOUNT || ' rows.');

     DBMS_OUTPUT.put_line (SQL%BULK_EXCEPTIONS.COUNT);
     --bpl (SQL%BULK_EXCEPTIONS.EXISTS (1));
     --DBMS_OUTPUT.put_line (SQL%BULK_EXCEPTIONS.FIRST);
     --DBMS_OUTPUT.put_line (SQL%BULK_EXCEPTIONS.LAST);
     --DBMS_OUTPUT.put_line (SQL%BULK_EXCEPTIONS.NEXT (1));
     --DBMS_OUTPUT.put_line (SQL%BULK_EXCEPTIONS.PRIOR (1));
     ROLLBACK;
END;
/