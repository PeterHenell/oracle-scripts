/* Retrieve two columns from the employees table
   and deposit into individual variables */

DECLARE
   l_employee   employees%ROWTYPE;
   l_salary     NUMBER;
BEGIN
   EXECUTE IMMEDIATE
      'SELECT last_name, salary FROM employees WHERE employee_id = 138'
      INTO l_employee.last_name, l_salary;

   DBMS_OUTPUT.put_line (l_employee.last_name);
END allrows_by;
/

/* Do same thing, but bind in the employee ID */

DECLARE
   l_employee   employees%ROWTYPE;
   l_salary     NUMBER;
BEGIN
   EXECUTE IMMEDIATE
      'SELECT last_name, salary FROM employees WHERE employee_id = :empid'
      INTO l_employee.last_name, l_salary
      USING 138;

   DBMS_OUTPUT.put_line (l_employee.last_name);
END allrows_by;
/

/* Fetch an entire row into a record. */

DECLARE
   l_employee   employees%ROWTYPE;
BEGIN
   EXECUTE IMMEDIATE 'SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = :empid'
      INTO l_employee
      USING 138;

   DBMS_OUTPUT.put_line (l_employee.last_name);
END allrows_by;
/