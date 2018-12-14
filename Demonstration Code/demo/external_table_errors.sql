DROP TABLE emp_load
/
CREATE TABLE emp_load
  (employee_number      CHAR(5),
   employee_last_name   CHAR(20))
ORGANIZATION EXTERNAL
  (TYPE oracle_loader
   DEFAULT DIRECTORY temp
   ACCESS PARAMETERS
     (RECORDS DELIMITED BY NEWLINE
      FIELDS (employee_number      CHAR(2),
              employee_last_name   CHAR(18)
             )
     )
   LOCATION ('info1.dat')
  )
/  

DECLARE
   x INTEGER;
BEGIN
   SELECT COUNT ( * )
     INTO x
     FROM emp_load;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ( DBMS_UTILITY.format_error_stack );
      DBMS_OUTPUT.put_line ( '---------------------' );
      DBMS_OUTPUT.put_line ( DBMS_UTILITY.format_error_backtrace );
END;
/*
ORA-29913: error in executing ODCIEXTTABLEOPEN callout
ORA-29400: data cartridge error
KUP-04043: table column not found in external source: EMPLOYEE_HIRE_DATE

ORA-29913: error in executing ODCIEXTTABLEOPEN callout
ORA-29400: data cartridge error
KUP-04040: file info1.dat in TEMP not found
*/
