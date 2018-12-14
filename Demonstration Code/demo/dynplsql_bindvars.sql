CREATE OR REPLACE PROCEDURE dyn_binds (
   col_in      IN     VARCHAR2,
   value_in    IN     NUMBER,
   total_out      OUT NUMBER,
   id_in       IN     NUMBER)
IS
BEGIN
   EXECUTE IMMEDIATE
         'UPDATE employees SET '
      || col_in
      || ' = :val WHERE employee_id = :val'
      USING value_in, id_in;

   EXECUTE IMMEDIATE
      'SELECT SUM (' || col_in || ') FROM employees'
      INTO total_out;
END;
/

DECLARE
   l_total_salary   NUMBER;
BEGIN
   EXECUTE IMMEDIATE
      'begin dyn_binds (:colname, :numval, :total_salary, :numval); end;'
      USING IN 'salary',
            IN 10000,
            OUT l_total_salary,
            IN 100;

   DBMS_OUTPUT.put_line (l_total_salary);
   ROLLBACK;
END;
/