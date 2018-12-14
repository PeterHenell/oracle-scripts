CREATE OR REPLACE PACKAGE end_labels
IS
   PROCEDURE record_and_continue (
      err_in   IN   PLS_INTEGER := SQLCODE
    , msg_in   IN   VARCHAR2 := NULL
   );
END end_labels;
/

CREATE OR REPLACE PACKAGE BODY end_labels
IS
   PROCEDURE record_and_continue (
      err_in   IN   PLS_INTEGER := SQLCODE
    , msg_in   IN   VARCHAR2 := NULL
   )
   IS
      PROCEDURE inner_program
      IS
      BEGIN
         NULL;
      END inner_program;

      PROCEDURE inner_program2
      IS
      BEGIN
         NULL;
      END inner_program2;
   BEGIN

      <<nested_block>>
      DECLARE
         local_var   NUMBER;
      BEGIN
         nested_block.local_var := 1;

         SELECT *
           INTO l_record
           FROM employees
          WHERE employee_id = nested_block.local_var;
      END nested_block;

      <<my_loop>>
      FOR rec IN (SELECT *
                    FROM employees)
      LOOP
         NULL;
      END LOOP my_loop;
   END record_and_continue;
END end_labels;
/