DROP TABLE err$_employees
/

BEGIN
   dbms_errlog_helper.create_objects ('EMPLOYEES');
END;
/

DECLARE
   TYPE namelist_t IS TABLE OF VARCHAR2 (5000);

   enames_with_errors   namelist_t
      := namelist_t ('ABC',
                     'DEF',
                     RPAD ('BIGBIGGERBIGGEST', 1000, 'ABC'),
                     'LITTLE',
                     RPAD ('BIGBIGGERBIGGEST', 3000, 'ABC'),
                     'SMITHIE');
BEGIN
   FORALL indx IN 1 .. enames_with_errors.COUNT
      UPDATE employees
         SET first_name = enames_with_errors (indx)
         LOG ERRORS REJECT LIMIT UNLIMITED;

   ROLLBACK;
END;
/

SELECT * FROM err$_employees
/