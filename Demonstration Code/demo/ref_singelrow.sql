Step 1 Replace single row queries with function. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Replace single row queries with function." 
 Create a function that returns the single row using an implicit cursor. The co
ode you see here was generated

Universal ID = {76347961-7F3D-4B9A-B347-AE99DC06654C}

CREATE OR REPLACE FUNCTION Or_Employee (
   EMPLOYEE_ID_in IN EMPLOYEE.EMPLOYEE_ID%TYPE
   )
   RETURN EMPLOYEE%ROWTYPE
IS
   retval EMPLOYEE%ROWTYPE;
BEGIN
   SELECT
         EMPLOYEE_ID,
         LAST_NAME,
         FIRST_NAME,
         MIDDLE_INITIAL,
         JOB_ID,
         MANAGER_ID,
         HIRE_DATE,
         SALARY,
         COMMISSION,
         DEPARTMENT_ID,
         EMPNO,
         ENAME,
         CREATED_BY,
         CREATED_ON,
         CHANGED_BY,
         CHANGED_ON
     INTO retval
     FROM EMPLOYEE
    WHERE
          EMPLOYEE_ID = EMPLOYEE_ID_in
      ;
   RETURN retval;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      -- Return an empty record
      RETURN retval;
   WHEN TOO_MANY_ROWS
   THEN
      RAISE;
END Or_Employee;
/
================================================================================
Step 2 Replace single row queries with function. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Replace single row queries with function."

Universal ID = {02174995-310F-4C5D-B42D-C5671E17E7A0}

PROCEDURE do_employee_stuff (id_in IN employee.employee_id%TYPE)
IS
   employee_r employee_cur%ROWTYPE;
BEGIN  
   employee_r := or_employee (employee_id_in => id_in); 
 
   IF employee_r.employee_id = id_in
   THEN
      -- more stuff to do.
   ELSE
      -- maybe error handling      
   END IF;
END;
================================================================================
Step 0: Problematic code for  Replace single row queries with function. (PL/SQL refactoring) 

The problematic code for that demonstrates "Replace single row queries with fun
nction. (PL/SQL refactoring)"

Universal ID = {89C1D170-2DD8-47A5-834D-6A49E937B8B4}

PROCEDURE do_employee_stuff (id_in IN NUMBER)
IS
   CURSOR employee_cur
   IS
      SELECT *
        FROM employee
       WHERE employee_id = id_in;
 
   employee   employee_cur%ROWTYPE;
BEGIN
   OPEN employee_cur;
 
   FETCH employee_cur
    INTO employee;
 
   IF employee_cur%FOUND
   THEN
      CLOSE employee_cur;
-- more stuff to do.
   ELSE
-- maybe error handling
      CLOSE employee_cur;
   END IF;
END;
================================================================================
