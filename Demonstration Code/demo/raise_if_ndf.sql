/*
"Traditional" one row lookup - treat NDF as a "hard" or unexpected error
*/

CREATE OR REPLACE FUNCTION id_for_name (
   department_name_in IN departments.department_name%TYPE
)
   RETURN departments.department_id%TYPE
IS
   l_return   departments.department_id%TYPE;
BEGIN
   SELECT department_id
     INTO l_return
     FROM departments
    WHERE department_name = department_name_in;

   RETURN l_return;
END id_for_name;
/

/*
Now suppose that I am using it in a batch procedure to update
data. Most of the time the department does not exist for 
this name, so I then want to add it.
*/

BEGIN
   FOR dept_rec IN (SELECT *
                      FROM dept_staging_table)
   LOOP
      BEGIN
         l_id := id_for_name (dept_rec.department_name);
         upd_department (dept_rec);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            /* It's a new department, so add it. */
            add_department (dept_rec);
      END;
   END LOOP;
END;
/

/* 

    And now the improvement: avoid putting application code
   in the exception section....
   
*/   

/*
Do not propagate the NDF exception unhandled.
But DO treat TOO_MANY_ROWS as a serious problem.
*/

CREATE OR REPLACE FUNCTION id_for_name (
   department_name_in IN departments.department_name%TYPE
 , raise_if_ndf_in IN BOOLEAN:= FALSE
 , ndf_value_in IN departments.department_id%TYPE:= NULL
)
   RETURN departments.department_id%TYPE
IS
   l_return   departments.department_id%TYPE;
BEGIN
   SELECT department_id
     INTO l_return
     FROM departments
    WHERE department_name = department_name_in;

   RETURN l_return;
EXCEPTION
   /*
   User gets to interpret as "unfortunate" exception.
   User can also specify a unique indicator of "row not found."
   */
   WHEN NO_DATA_FOUND
   THEN
      IF raise_if_ndf_in
      THEN
         RAISE;
      ELSE
         RETURN ndf_value_in;
      END IF;
   WHEN TOO_MANY_ROWS
   THEN
      q$error_manager.raise_unanticipated (
         text_in     => 'Multiple rows found for department name'
       , name1_in    => 'DEPARTMENT_NAME'
       , value1_in   => department_name_in
      );
END id_for_name;
/

DECLARE
   c_no_such_dept   CONSTANT PLS_INTEGER := -1;
BEGIN
   FOR dept_rec IN (SELECT *
                      FROM dept_staging_table)
   LOOP
      l_id :=
         id_for_name (dept_rec.department_name
                    , raise_if_ndf_in   => FALSE
                    , ndf_value_in      => c_no_such_dept
                     );

      IF l_id = c_no_such_dept
      THEN
         /* It's a new department, so add it. */
         add_department (dept_rec);
      ELSE
         upd_department (dept_rec);
      END IF;
   END LOOP;
END;
/