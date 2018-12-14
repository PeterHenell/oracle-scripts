/* 
   Run static SQL version of showemps to compare to dyanmic.
   Run showemps.tst to compare the two. */
CREATE OR REPLACE PROCEDURE showemps2
IS
   myvar VARCHAR2(100);
BEGIN
   FOR rec IN (SELECT employee_id, last_name FROM employee)
   LOOP
      myvar := TO_CHAR (rec.employee_id) || '=' || rec.last_name;
      p.l (myvar);
   END LOOP;
END;
/
