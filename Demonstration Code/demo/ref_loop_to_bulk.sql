Step 0: Problematic code for Convert cursor loop with DML to bulk processing. (PL/SQL refactoring)

The code in this script follows the old fashioned way of doing things: set up a
a cursor FOR loop and for each row processed, issue the appropriate DML. It wor
rks just fine, but can be very small for large volumes of data.

To convert this code, you will take the following three steps:

1. Declare collections for each piece of data queried.

2. Replace the cursor loop with a BULK COLLECT statement.

3. Write a FORALL statement for each DML operation in the loop.

Universal ID = {D7287D4F-529D-4697-BB55-E708CD895DC2}

CREATE OR REPLACE PROCEDURE upd_for_dept1 (
   dept_in IN employee.department_id%TYPE
  ,newsal IN employee.salary%TYPE
)
-- One step with cursor FOR loop
IS
   CURSOR emp_cur
   IS
      SELECT employee_id, salary, hire_date
        FROM employee
       WHERE department_id = dept_in;
BEGIN
   FOR rec IN emp_cur
   LOOP
      INSERT INTO employee_history
                  (employee_id, salary, hire_date
                  )
           VALUES (rec.employee_id, rec.salary, rec.hiredate
                  );
 
      UPDATE employee
         SET salary = newsal
       WHERE employee_id = rec.employee_id;
   END LOOP;
END upd_for_dept1;
/
================================================================================
Step 1 Convert cursor loop with DML to bulk processing. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Convert cursor loop with DML and conditiona
al logic to bulk processing."

Declare collections for each piece of data queried.

Use the script "Declare an associative array for each table column" - {AE0DA635
5-8BF4-4AE5-B30C-4AA595181B0C} - to generate these declarations quickly.

Universal ID = {EBEF1130-76EF-46AF-A867-5281EF808D24}

CREATE OR REPLACE PROCEDURE upd_for_dept2 (
   dept_in   IN   employee.department_id%TYPE,
   newsal    IN   employee.salary%TYPE
)
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;
   employees    employee_tt;
 
   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;
   salaries     salary_tt;
 
   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;
   hire_dates   hire_date_tt;
BEGIN
================================================================================
Step 2 Convert cursor loop with DML to bulk processing. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Convert cursor loop with DML to bulk proces
ssing."

Query the data into the collections with a BULK COLLECT statement.

Notice that this will retrieve all rows, since we don't have a LIMIT clause.

Universal ID = {3982B22B-279C-47C4-8ECB-082E03EA7058}

CREATE OR REPLACE PROCEDURE upd_for_dept2 (
   dept_in   IN   employee.department_id%TYPE,
   newsal    IN   employee.salary%TYPE
)
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;
   employees    employee_tt;
 
   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;
   salaries     salary_tt;
 
   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;
   hire_dates   hire_date_tt;
BEGIN
   SELECT employee_id, salary, hire_date
   BULK COLLECT INTO employees, salaries, hire_dates
     FROM employee
    WHERE department_id = dept_in;
================================================================================
Step 3 Convert cursor loop with DML to bulk processing. (PL/SQL refactoring)

Step 3 in the refactoring of topic "Convert cursor loop with DML to bulk proces
ssing."

Finish the conversion process by adding a FORALL statement for each of the two 
 DML statements.

Universal ID = {19EBEA3B-8CE0-4B41-9A4C-A51D506C40F3}

CREATE OR REPLACE PROCEDURE upd_for_dept2 (
   dept_in   IN   employee.department_id%TYPE,
   newsal    IN   employee.salary%TYPE
)
-- Three steps with BULK COLLECT and FORALL
IS
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;
   employees    employee_tt;
 
   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;
   salaries     salary_tt;
 
   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;
   hire_dates   hire_date_tt;
BEGIN
   SELECT employee_id, salary, hire_date
   BULK COLLECT INTO employees, salaries, hire_dates
     FROM employee
    WHERE department_id = dept_in;
 
   FORALL indx IN employees.FIRST .. employees.LAST
      INSERT INTO employee_history
                  (employee_id, salary, hire_date
                  )
           VALUES (employees (indx), salaries (indx), hire_dates (indx)
                  );
                  
   FORALL indx IN employees.FIRST .. employees.LAST
      UPDATE employee
         SET salary = newsal,
             hire_date = hire_dates (indx)
       WHERE employee_id = employees (indx);
END upd_for_dept2;
================================================================================
