@@pl.sp
@@bpl.sp
@@eqtables.sf

DROP TABLE employee_compare;

CREATE TABLE employee_compare AS SELECT * FROM employee;

BEGIN
   bpl (eqtables ('employee', 'employee_compare'));

   DELETE FROM employee_compare;
   
   bpl (eqtables ('employee', 'employee_compare'));

   bpl (eqtables ('employee', 'emp'));
   
END;
/
   
