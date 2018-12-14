Step 0: Problematic code for Convert cursor loop with DML and conditional logic to bulk processing. (PL/SQL refactoring)

The code in this script follows the old fashioned way of doing things: set up a
a cursor FOR loop and for each row processed, issue the appropriate DML. In add
dition, there is conditional logic; the same DML does not necessarily occur for
r each row queried. This code works just fine, but can be very small for large 
 volumes of data. 

To convert this code, you will take the following steps:

1. Declare collections for each piece of data queried.

2. Replace the cursor loop with a BULK COLLECT statement.

3. Pre-process the collections populated by BULK COLLECT to partition the data 
 so that it reflects the conditional logic in the cursor loop. 

4. Execute a FORALL statement for each DML operation in the loop, using the app
propriate array to drive the processing.

Universal ID = {F780EB9C-8B84-4C68-9CD5-68C18E9A0930}

CREATE OR REPLACE PROCEDURE upd_for_dept3 (
   dept_in   IN   employee.department_id%TYPE,
   newsal    IN   employee.salary%TYPE
)
-- One step with simple loop and conditional logic
IS
   CURSOR emp_cur
   IS
      SELECT employee_id, salary, hire_date
        FROM employee
       WHERE department_id = dept_in;
 
   emp_rec   emp_cur%ROWTYPE;
BEGIN
   OPEN emp_cur;
 
   LOOP
      FETCH emp_cur INTO emp_rec;
      EXIT WHEN emp_cur%NOTFOUND;
 
      IF comp_analysis.eligible (emp_rec.employee_id)
      THEN
         INSERT INTO employee_history
                     (employee_id, salary,
                      hire_date, activity
                     )
              VALUES (emp_rec.employee_id, emp_rec.salary,
                      emp_rec.hire_date, 'RAISE GIVEN'
                     );
 
         UPDATE employee
            SET salary = newsal
          WHERE employee_id = emp_rec.employee_id;
      ELSE
         INSERT INTO employee_history
                     (employee_id, salary,
                      hire_date, activity
                     )
              VALUES (emp_rec.employee_id, emp_rec.salary,
                      emp_rec.hire_date, 'RAISE DENIED'
                     );
      END IF;
   END LOOP;
END upd_for_dept3;
================================================================================
Step 1 Convert cursor loop with DML and conditional logic to bulk processing. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Convert cursor loop with DML and conditiona
al logic to bulk processing."

Declare collections for each piece of data queried. In this scenario, we first 
 declare a collection of records for the specific set of columns being queried.
. We can use a collection of records becuase this collection will only be used 
 as the source collection from which the partitioned collections will be popula
ated. 

Remember: a collection of records cannot be used in a FORALL statement (at leas
st through Oracle10g Release 1).

Use the script "Declare an associative array for each table column" - {AE0DA635
5-8BF4-4AE5-B30C-4AA595181B0C} - to generate these declarations quickly.

Universal ID = {F592B814-04F7-452E-B4D2-17427748BEB6}

CREATE OR REPLACE PROCEDURE Upd_For_Dept4 (
   dept_in   IN   employee.department_id%TYPE
  ,newsal    IN   employee.salary%TYPE
)
-- Handle conditional logic by partitioning the table.
IS
   TYPE emp_info_rt IS RECORD (
      employee_id   employee.employee_id%TYPE
     ,salary        employee.salary%TYPE
     ,hire_date     employee.hire_date%TYPE
   );
 
   TYPE emp_info_tt IS TABLE OF emp_info_rt
      INDEX BY PLS_INTEGER;
 
   emp_info              emp_info_tt;
 
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_employees    employee_tt;
   denied_employees      employee_tt;
 
   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_salaries     salary_tt;
   denied_salaries       salary_tt;
 
   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_hire_dates   hire_date_tt;
   denied_hire_dates     hire_date_tt;
   l_row                 PLS_INTEGER;
BEGIN
 
================================================================================
Step 2 Convert cursor loop with DML and conditional logic to bulk processing. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Convert cursor loop with DML and conditiona
al logic to bulk processing."

Use BULK COLLECT to quickly "dump" the data into my collection of records.

Then iterate through the contents of the collection and move the data to either
r the approved or denied collections.

Universal ID = {81F35110-08B7-4B68-9F94-C5B2E391F5CC}

CREATE OR REPLACE PROCEDURE Upd_For_Dept4 (
   dept_in   IN   employee.department_id%TYPE
  ,newsal    IN   employee.salary%TYPE
)
-- Handle conditional logic by partitioning the table.
IS
   TYPE emp_info_rt IS RECORD (
      employee_id   employee.employee_id%TYPE
     ,salary        employee.salary%TYPE
     ,hire_date     employee.hire_date%TYPE
   );
 
   TYPE emp_info_tt IS TABLE OF emp_info_rt
      INDEX BY PLS_INTEGER;
 
   emp_info              emp_info_tt;
 
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_employees    employee_tt;
   denied_employees      employee_tt;
 
   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_salaries     salary_tt;
   denied_salaries       salary_tt;
 
   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_hire_dates   hire_date_tt;
   denied_hire_dates     hire_date_tt;
   l_row                 PLS_INTEGER;
BEGIN
   SELECT employee_id
         ,salary
         ,hire_date
   BULK COLLECT INTO emp_info
     FROM employee
    WHERE department_id = dept_in;
 
   IF emp_info.COUNT > 0
   THEN
      FOR indx IN emp_info.FIRST .. emp_info.LAST
      LOOP
         IF comp_analysis.eligible (emp_info (indx).employee_id)
         THEN
            l_row := approved_employees.COUNT + 1;
            approved_employees (l_row) := emp_info (indx).employee_id;
            approved_salaries (l_row) := emp_info (indx).salary;
            approved_hire_dates (l_row) := emp_info (indx).hire_date;
         ELSE
            l_row := denied_employees.COUNT + 1;
            denied_employees (l_row) := emp_info (indx).employee_id;
            denied_salaries (l_row) := emp_info (indx).salary;
            denied_hire_dates (l_row) := emp_info (indx).hire_date;
         END IF;
      END LOOP;
================================================================================
Step 3 Convert cursor loop with DML and conditional logic to bulk processing. (PL/SQL refactoring)

Step 3 in the refactoring of topic "Convert cursor loop with DML and conditiona
al logic to bulk processing."

My approved and denied collections have been created, so now I can call the FOR
RALL statrement THREE TIMES: 

* Update the history table for approved raises.

* Update the history table for denied raises.

* Update the employee table for those employees with approved raises.



Universal ID = {53073FDA-5908-431D-A508-8144E933028F}

CREATE OR REPLACE PROCEDURE Upd_For_Dept4 (
   dept_in   IN   employee.department_id%TYPE
  ,newsal    IN   employee.salary%TYPE
)
-- Handle conditional logic by partitioning the table.
IS
   TYPE emp_info_rt IS RECORD (
      employee_id   employee.employee_id%TYPE
     ,salary        employee.salary%TYPE
     ,hire_date     employee.hire_date%TYPE
   );
 
   TYPE emp_info_tt IS TABLE OF emp_info_rt
      INDEX BY PLS_INTEGER;
 
   emp_info              emp_info_tt;
 
   TYPE employee_tt IS TABLE OF employee.employee_id%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_employees    employee_tt;
   denied_employees      employee_tt;
 
   TYPE salary_tt IS TABLE OF employee.salary%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_salaries     salary_tt;
   denied_salaries       salary_tt;
 
   TYPE hire_date_tt IS TABLE OF employee.hire_date%TYPE
      INDEX BY BINARY_INTEGER;
 
   approved_hire_dates   hire_date_tt;
   denied_hire_dates     hire_date_tt;
   l_row                 PLS_INTEGER;
BEGIN
   SELECT employee_id
         ,salary
         ,hire_date
   BULK COLLECT INTO emp_info
     FROM employee
    WHERE department_id = dept_in;
 
   IF emp_info.COUNT > 0
   THEN
      FOR indx IN emp_info.FIRST .. emp_info.LAST
      LOOP
         IF comp_analysis.eligible (emp_info (indx).employee_id)
         THEN
            l_row := approved_employees.COUNT + 1;
            approved_employees (l_row) := emp_info (indx).employee_id;
            approved_salaries (l_row) := emp_info (indx).salary;
            approved_hire_dates (l_row) := emp_info (indx).hire_date;
         ELSE
            l_row := denied_employees.COUNT + 1;
            denied_employees (l_row) := emp_info (indx).employee_id;
            denied_salaries (l_row) := emp_info (indx).salary;
            denied_hire_dates (l_row) := emp_info (indx).hire_date;
         END IF;
      END LOOP;
 
      FORALL indx IN approved_employees.FIRST .. approved_employees.LAST SAVE EXCEPTIONS
         INSERT INTO employee_history
                     (employee_id, salary
                     ,hire_date, activity
                     )
              VALUES (approved_employees (indx), approved_salaries (indx)
                     ,approved_hire_dates (indx), 'RAISE GIVEN'
                     );
      FORALL indx IN denied_employees.FIRST .. denied_employees.LAST SAVE EXCEPTIONS
         INSERT INTO employee_history
                     (employee_id, salary
                     ,hire_date, activity
                     )
              VALUES (denied_employees (indx), denied_salaries (indx)
                     ,denied_hire_dates (indx), 'RAISE DENIED'
                     );
      FORALL indx IN approved_employees.FIRST .. approved_employees.LAST SAVE EXCEPTIONS
         UPDATE employee
            SET salary = newsal
               ,hire_date = approved_hire_dates (indx)
          WHERE employee_id = approved_employees (indx);
   END IF;
END Upd_For_Dept4;
/
================================================================================
