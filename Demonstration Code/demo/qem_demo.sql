/* 
Raise and propagate an Oracle error, then
trap that error and extract information about the error.
*/

DROP TABLE qem_demo_table
/

CREATE TABLE qem_demo_table
(
   department_id   NUMBER PRIMARY KEY,
   salary          NUMBER
)
/

BEGIN
   INSERT INTO qem_demo_table
        VALUES (1, 20000);
END;
/


CREATE OR REPLACE PROCEDURE hr_insert (
   department_id_in IN PLS_INTEGER)
IS
   l_max_salary   NUMBER;
BEGIN
   l_max_salary :=
      CASE WHEN department_id_in > 100 THEN 10000 ELSE 20000 END;

   INSERT INTO qem_demo_table
        VALUES (department_id_in, l_max_salary);
END hr_insert;
/

BEGIN
   hr_insert (1);
END;
/

/* Now switch to QEM */

CREATE OR REPLACE PROCEDURE hr_insert (
   department_id_in IN PLS_INTEGER)
IS
   l_max_salary   NUMBER;
BEGIN
   l_max_salary :=
      CASE WHEN department_id_in > 100 THEN 10000 ELSE 20000 END;

   INSERT INTO qem_demo_table
        VALUES (department_id_in, l_max_salary);
EXCEPTION
   WHEN OTHERS
   THEN
      /* Trap the error, add some context, pass it along. */

      /* You can also use add_context to add as many name-value
         pairs as you like. Max of 5 supported through the raise
         programs. */

      q$error_manager.raise_unanticipated (
         name1_in    => 'DEPARTMENT ID',
         value1_in   => department_id_in,
         name2_in    => 'MAX SALARY',
         value2_in   => l_max_salary,
         name3_in    => 'TABLE_NAME',
         value3_in   => 'DEPARTMENTS',
         name4_in    => 'OWNER',
         value4_in   => USER,
         name5_in    => 'CONSTRAINT_NAME',
         value5_in   => 'Primary Key');
END hr_insert;
/

BEGIN
   hr_insert (1);
EXCEPTION
   WHEN OTHERS
   THEN
      DECLARE
         l_error   q$error_manager.error_info_rt;
      BEGIN
         q$error_manager.get_error_info (l_error);
         DBMS_OUTPUT.put_line ('');
         DBMS_OUTPUT.put_line ('Error in DEPT_SAL Procedure:');
         DBMS_OUTPUT.put_line ('Code = ' || l_error.code);
         DBMS_OUTPUT.put_line ('Name = ' || l_error.name);
         DBMS_OUTPUT.put_line ('Text = ' || l_error.text);
         DBMS_OUTPUT.put_line (
            'Error Stack = ' || l_error.error_stack);
      END;
END;
/