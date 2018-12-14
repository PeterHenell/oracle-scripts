CREATE OR REPLACE PROCEDURE give_raise (
   employee_id_in IN employee_tp.id_t
 , raise_in IN employee_tp.salary_t
)
IS
   l_name employee_rp.fullname_t;
   salary employee_tp.salary_t;

   PROCEDURE get_employee_info (
      employee_id_in IN employee_tp.id_t
    , employee_rec_out OUT employee_tp.employee_rt
   )
   IS
   BEGIN
      SELECT last_name || ',' || first_name
        INTO l_name
        FROM employee
       WHERE employee_id = employee_id;

      SELECT salary
        INTO salary
        FROM employee
       WHERE employee_id = employee_id;
   END;

   PROCEDURE set_new_salary (
      employee_rec_in IN employee_tp.employee_rt
    , salary_in IN employee_tp.salary_t
   )
   IS
   BEGIN
      employee_cp.upd
	  
      UPDATE employee
         SET salary = salary + money
       WHERE employee_id = employee_id;
   END;

   PROCEDURE report_info (
      employee_rec_in IN employee_tp.employee_rt
    , salary_in IN employee_tp.salary_t
    , new_salary OUT employee_tp.salary_t
   )
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('Report on salary increase for:');
      DBMS_OUTPUT.put_line (l_name);
      DBMS_OUTPUT.put_line ('Old salary is ' || salary);
      DBMS_OUTPUT.put_line ('New salary is ' || salary + money);
   END;
BEGIN
   get_employee_info (employee_id, employee_rec);
   set_new_salary (employee_rec, salary, new_salary);
   report_info (employee_rec, salary, new_salary);;
END;