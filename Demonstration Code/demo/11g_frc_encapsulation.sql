/* 
   In our "high level" application code (as opposed to
   low-level error loggers and other utilities), most
   developers write whatever SQL they need wherever they
   need it.
   
   And, of course, the same or very similar statements
   are needed over and over again, especially for key
   tables.
   
   The result is a proliferation of SQL: hard to optimize,
   very difficult to maintain, quite expensive to upgrade.
*/

CREATE OR REPLACE PROCEDURE do_stuff_with_employee (
   employee_id_in IN employees.employee_id%TYPE)
IS
   l_employee   employees%ROWTYPE;
   l_manager   employees%ROWTYPE;
BEGIN
   SELECT *
     INTO l_employee
     FROM employees
    WHERE employee_id = employee_id_in;
    
   /* Do some stuff... and then, again! */

   SELECT *
     INTO l_manager
     FROM employees
    WHERE employee_id = l_employee.manager_id;   
END;
/

/* 
   The approach I take is to write the query once
   and hide it behind a function interface, as in:
*/

CREATE OR REPLACE PACKAGE employees_sql
IS
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE;
END;
/

CREATE OR REPLACE PACKAGE BODY employees_sql
IS
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE
   IS
      onerow_rec   employees%ROWTYPE;
   BEGIN
      SELECT *
        INTO onerow_rec
        FROM employees
       WHERE employee_id = employee_id_in;

      RETURN onerow_rec;
   END;
END;
/

/*
   The result is less code to write and maintain
   (increased productivity!) and a "single point of definition"
   for this particular SQL "service".
   
   And now when I decide I would like result cache queries
   against the employees table, I add RESULT_CACHE in just one
   place (spec and body) and I am done!
*/
      
CREATE OR REPLACE PROCEDURE do_stuff_with_employee (
   employee_id_in IN employees.employee_id%type)
IS
   l_employee   employees%ROWTYPE;
   l_manager   employees%ROWTYPE;
BEGIN
   l_employee := := employees_sql.onerow (employee_id_in);
    
   /* Do some stuff... and then, again, but now 
      just a function call! */

   l_manager := employees_sql.onerow (l_employee.manager_id);
END;
/

