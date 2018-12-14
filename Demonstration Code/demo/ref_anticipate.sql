Step 1 Write handlers for errors you can anticipate. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Write handlers for errors you can anticipat
te."

Let's move the query to a function. Then we can put the error handling within t
the function.

The logic for this error handling is as follows:

* A NO_DATA_FOUND exception might not necessarily be an error. Perhaps the user
r calls this function with an ID they expect and want to find no rows. So rathe
er than allow the exception to go unhandled, we return NULL, which is a valid i
indicator of "row not found" IN THIS CASE. You need to make sure that the value
e you pass back for this condition will be a good indicator for your situation.

* With TOO_MANY_ROWS we have a data integrity problem - two or more rows with t
the same primary key. So in this case, I propagate the error unhandled. You cou
uld also record the error and then re-raise it.

Universal ID = {F640AD09-AE5E-499E-B054-B2B01C9260BF}

CREATE OR REPLACE PACKAGE BODY Fullname_Pkg
AS
   FUNCTION fullname (
      employee_id_in IN employee.employee_id%TYPE
   )
      RETURN VARCHAR2
   IS
      retval VARCHAR2(200);
   BEGIN
      SELECT last_name || ', ' || first_name
        INTO retval
        FROM employee
       WHERE employee_id = employee_id_in;
 
      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN TOO_MANY_ROWS
      THEN
         RAISE;
   END;
END;
/
 
================================================================================
Step 2 Write handlers for errors you can anticipate. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Write handlers for errors you can anticipat
te."

Taking the code in Step 1 a bit further, let's provide a more robust implementa
ation that defines a SUBTYPE for full name, and gives us some flexibility in th
he form of the full name that is passed back.

Universal ID = {9EC0961F-FEA4-4DD5-8643-023C9E0E6E3C}

CREATE OR REPLACE PACKAGE Fullname_Pkg
AS
   SUBTYPE fullname_t IS VARCHAR2 (1000);
 
   FUNCTION fullname (
      l employee.last_name%TYPE
    , f employee.first_name%TYPE
    , use_f_l_in IN BOOLEAN := FALSE         
   )
      RETURN fullname_t;
 
   FUNCTION fullname (
      l employee.last_name%TYPE
    , f employee.first_name%TYPE
    , use_f_l_in IN PLS_INTEGER := 0
   )
      RETURN fullname_t;
 
   FUNCTION fullname (
      employee_id_in IN employee.employee_id%TYPE
    , use_f_l_in IN BOOLEAN := FALSE         
   )
      RETURN fullname_t;
END Fullname_Pkg;
/
 
CREATE OR REPLACE PACKAGE BODY Fullname_Pkg
AS
   FUNCTION fullname (
      l employee.last_name%TYPE
    , f employee.first_name%TYPE
    , use_f_l_in IN BOOLEAN := FALSE
   )
      RETURN fullname_t
   IS
   BEGIN
      IF use_f_l_in
      THEN
         RETURN f || ' ' || l;
      ELSE
         RETURN l || ',' || f;
      END IF;
   END;
 
   FUNCTION fullname (
      l employee.last_name%TYPE
    , f employee.first_name%TYPE
    , use_f_l_in IN PLS_INTEGER := 0
   )
      RETURN fullname_t
   IS
   BEGIN
      RETURN fullname (l, f, use_f_l_in = 1);
   END;
 
   FUNCTION fullname (
      employee_id_in IN employee.employee_id%TYPE
    , use_f_l_in IN BOOLEAN := FALSE          
   )
      RETURN fullname_t
   IS
      retval fullname_t;
      v_tf PLS_INTEGER;
   BEGIN
      IF use_f_l_in
      THEN
         v_tf := 1;
      ELSE
         v_tf := 0;
      END IF;
 
      SELECT fullname (last_name, first_name, v_tf)
        INTO retval
        FROM employee
       WHERE employee_id = employee_id_in;
 
      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN TOO_MANY_ROWS
      THEN
         RAISE;
   END;
END Fullname_Pkg;
/
================================================================================
Step 0: Problematic code for  Write handlers for errors you can anticipate. (PL/SQL refactoring) 

The problematic code for that demonstrates "Write handlers for errors you can a
anticipate. (PL/SQL refactoring)"

A classic example of bad code. I put the implicit cursor directly in my block o
of code, but neglect to provide any error handling. The thinking behind such co
ode goes like this:

"We are always going to have just one row returned by this query."

Unfortunately, whenever a programmer says "never" or "always" they are almost c
certainly writing a mistake into their program. 

Universal ID = {26E9E3F1-995C-47EA-8B75-D2D76DE1FABB}

CREATE OR REPLACE PROCEDURE process_employee (
   employee_id IN NUMBER)
IS
   l_name VARCHAR2(100);
BEGIN
   SELECT last_name || ',' || first_name
     INTO l_name
     FROM employee
    WHERE employee_id = process_employee.employee_id;
    
   -- Lots more processing logic.
 
   COMMIT;
END;
================================================================================
