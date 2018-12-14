CREATE OR REPLACE PROCEDURE updnumval (col_in     IN VARCHAR2,
                                       start_in   IN DATE,
                                       end_in     IN DATE,
                                       val_in     IN NUMBER)
IS
BEGIN
   EXECUTE IMMEDIATE
         'UPDATE employees SET '
      || col_in
      || ' = :val 
        WHERE hire_date BETWEEN :lodate AND :hidate'
      USING val_in, start_in, end_in;
END;
/

BEGIN
   updnumval ('salary',
              DATE '2002-01-01',
              DATE '2002-12-31',
              20000);
END;
/

SELECT *
  FROM employees
 WHERE salary = 20000
/