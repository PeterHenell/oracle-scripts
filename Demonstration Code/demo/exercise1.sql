CREATE OR REPLACE PROCEDURE give_raise (
   employee_id IN number, money integer)
IS
   l_name VARCHAR2(200);
   salary integer;
BEGIN
   SELECT last_name || ',' ||
          first_name
     INTO l_name
     FROM employee
    WHERE employee_id = employee_id;
    
   SELECT salary into salary
     FROM employee
    WHERE employee_id = employee_id;

   update employee set salary = salary + money
    where employee_id = employee_id;

   dbms_output.put_line ('Report on salary increase for:');
   dbms_output.put_line (l_name);
   dbms_output.put_line ('Old salary is ' || salary);
   dbms_output.put_line (
      'New salary is ' || salary + money);
END;
