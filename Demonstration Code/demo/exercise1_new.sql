create or replace package emp_info_pkg 
AS
   SUBTYPE fullname_t IS VARCHAR2 (1000);
   subtype emp_sal is employee.salary%type;

   FUNCTION fullname (employee_id_in IN employee.employee_id%type        
   ) return fullname_t is
   begin
   select last_name ||','||first_name
   into fullname_t
   from employee
   where employee_id = employee_id_in;
      RETURN fullname_t;
	  end;
	  function salary ( employee_id_in IN employee.employee_id%type 
	  ) return number is begin
	  SELECT salary into emp_sal
      FROM employee
      WHERE employee_id = employee_id_in;
	
	  return emp_sal;

end;
end;
/

create or replace package upd_emp_data 
is
new_sal 
begin
function upd_salary(employee_id_in IN employee.employee_id%type,
money IN employee.salary%type)  
   update employee set salary = emp_sal + money
    where employee_id = employee_id;
end;


create or replace package disp_emp_data (cur_sal_in in number)
dbms_output.put_line ('Report on salary increase for:');
   dbms_output.put_line (l_name);
   dbms_output.put_line ('Old salary is ' || cur_sal);
   dbms_output.put_line (
      'New salary is ' || salary );
)



CREATE OR REPLACE PROCEDURE give_raise (
   employee_id_in IN number, money integer)
IS
   l_name employee_rp.fullname_t;
BEGIN

	 l_name := emp_info_pkg.fullname(employee_id_in);
     cur_sal := emp_info_pkg.salary(employee_id_in);
	 upd_salary(employee_id_in,money);
	 disp_emp_data (cur_sal, money);
END;