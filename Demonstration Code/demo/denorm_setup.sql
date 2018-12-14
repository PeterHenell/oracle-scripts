CREATE OR REPLACE TYPE employee_ids_ntt IS TABLE OF INTEGER;
/

/* Assume max of 1000 employees per department. Just to use a varray! */

CREATE OR REPLACE TYPE uc_employee_names_vat IS VARRAY ( 1000 ) OF VARCHAR2 ( 4000 );
/

CREATE  TABLE department_denorms (
  department_id     NUMBER(6),
  max_salary NUMBER,
  employee_names uc_employee_names_vat,
  employee_ids employee_ids_ntt )
  NESTED TABLE employee_ids STORE AS nested_id_table
/
--
ALTER TABLE department_denorms ADD (
  CONSTRAINT department_denorms_fk
 FOREIGN KEY (department_id)
 REFERENCES departments (department_id) ON DELETE CASCADE)
/
/* Initial population of the denormalized table */

TRUNCATE TABLE department_denorms
/

DECLARE
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_employees employees_aat;

   TYPE denorms_aat IS TABLE OF department_denorms%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_denorms denorms_aat;
   l_index departments.department_id%TYPE;
BEGIN
   SELECT *
   BULK COLLECT INTO l_employees
     FROM employees;

   FOR indx IN 1 .. l_employees.COUNT
   LOOP
      -- Initialize the row if necessary.
      l_index := l_employees ( indx ).department_id;

      IF NOT l_denorms.EXISTS ( )
      THEN
         l_denorms ( l_index ).department_id := l_index;
         l_denorms ( l_index ).max_salary := 0;
         l_denorms ( l_index ).employee_ids := employee_ids_ntt ( );
         l_denorms ( l_index ).employee_names := uc_employee_names_vat ( );
      END IF;

-- Set the maximum salary.
      l_denorms ( l_index ).max_salary :=
         GREATEST ( l_denorms ( l_index ).max_salary
                  , l_employees ( indx ).salary
                  );
-- Add the upper cased name.
      l_denorms ( l_index ).employee_names.EXTEND;
      l_denorms ( l_index ).employee_names
                                    ( l_denorms ( l_index ).employee_names.COUNT
                                    ) :=
         UPPER (    l_employees ( indx ).first_name
                 || ' '
                 || l_employees ( indx ).last_name
               );
-- Add the employee id.
      l_denorms ( l_index ).employee_ids.EXTEND;
      l_denorms ( l_index ).employee_ids
                                      ( l_denorms ( l_index ).employee_ids.COUNT
                                      ) := l_employees ( indx ).employee_id;
   END LOOP;

   -- Push the data into the denorm table.
   FORALL indx IN INDICES OF l_denorms
      INSERT INTO department_denorms
           VALUES l_denorms ( indx );
   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE denorm_demo_pkg
IS
   PROCEDURE show_ids (
      department_id_in   IN   department_denorms.department_id%TYPE
   );

   PROCEDURE show_names (
      department_id_in   IN   department_denorms.department_id%TYPE
   );

   PROCEDURE add_id (
      department_id_in   IN   department_denorms.department_id%TYPE
    , employee_id_in     IN   employees.employee_id%TYPE
   );

   PROCEDURE add_name (
      department_id_in   IN   department_denorms.department_id%TYPE
    , NAME_IN            IN   VARCHAR2
   );

   PROCEDURE add_name (
      department_id_in   IN   department_denorms.department_id%TYPE
    , employee_id_in     IN   employees.employee_id%TYPE
   );

   PROCEDURE show_all;
END denorm_demo_pkg;
/

CREATE OR REPLACE PACKAGE BODY denorm_demo_pkg
IS
   PROCEDURE show_ids (
      department_id_in   IN   department_denorms.department_id%TYPE
   )
   IS
      l_ids employee_ids_ntt;
   BEGIN
      DBMS_OUTPUT.put_line ( 'Employee IDs for department '
                             || department_id_in
                           );

      SELECT employee_ids
        INTO l_ids
        FROM department_denorms
       WHERE department_id = department_id_in;

      FOR indx IN 1 .. l_ids.COUNT
      LOOP
         DBMS_OUTPUT.put_line ( '   ' || l_ids ( indx ));
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line
                             (    '*** No employee IDs found for department '
                               || department_id_in
                             );
   END show_ids;

   PROCEDURE show_names (
      department_id_in   IN   department_denorms.department_id%TYPE
   )
   IS
      l_names uc_employee_names_vat;
   BEGIN
      DBMS_OUTPUT.put_line (    'Employee names for department '
                             || department_id_in
                           );

      SELECT employee_names
        INTO l_names
        FROM department_denorms
       WHERE department_id = department_id_in;

      FOR indx IN 1 .. l_names.COUNT
      LOOP
         DBMS_OUTPUT.put_line ( '   ' || l_names ( indx ));
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line
                            (    '***No employee names found for department '
                              || department_id_in
                            );
   END show_names;

   PROCEDURE add_id (
      department_id_in   IN   department_denorms.department_id%TYPE
    , employee_id_in     IN   employees.employee_id%TYPE
   )
   IS
   BEGIN
--   update department_denorms
      NULL;
   END add_id;

   PROCEDURE add_name (
      department_id_in   IN   department_denorms.department_id%TYPE
    , NAME_IN            IN   VARCHAR2
   )
   IS
   BEGIN
--   update department_denorms
      NULL;
   END add_name;

   PROCEDURE add_name (
      department_id_in   IN   department_denorms.department_id%TYPE
    , employee_id_in     IN   employees.employee_id%TYPE
   )
   IS
   BEGIN
--   update department_denorms
      NULL;
   END add_name;

   PROCEDURE show_all
   IS
      TYPE departments_aat IS TABLE OF departments%ROWTYPE
         INDEX BY PLS_INTEGER;

      l_departments departments_aat;
   BEGIN
      SELECT *
      BULK COLLECT INTO l_departments
        FROM departments;

      FOR indx IN 1 .. l_departments.COUNT
      LOOP
         show_ids ( l_departments ( indx ).department_id );
         show_names ( l_departments ( indx ).department_id );
      END LOOP;
   END;
END denorm_demo_pkg;
/

/* Now create a trigger to manage the denorm table. */

CREATE OR REPLACE TRIGGER populate_denorms_tr
   AFTER INSERT OR UPDATE
   ON employees
   FOR EACH ROW
DECLARE
BEGIN
   SELECT *
     INTO l_denorm
     FROM department_denorms
    WHERE department_id = :NEW.department_id;
END type_table_bir;
/
