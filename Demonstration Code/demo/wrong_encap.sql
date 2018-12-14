CREATE OR REPLACE PROCEDURE add_test (
   NAME_IN IN VARCHAR2
 , program_owner_in IN VARCHAR2
 , program_name_in IN VARCHAR2
 , overload_in IN PLS_INTEGER
 , description_in IN VARCHAR2
)
IS
   l_display_name   VARCHAR2 (500)
      := NVL (NAME_IN
            , 'Unit test for ' || program_owner_in || '.' || program_name_in
             );
BEGIN
   SELECT 'Unit test for ' || NAME
     INTO l_display_name
     FROM qu_unit_test
    WHERE program_owner = program_owner_in AND program_name = program_name_in;

   -- Exists, so update with possibly new information.
   NULL;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      -- Time to create a new test!
      INSERT INTO qu_unit_test
                  (NAME, program_owner, program_name
                 , overload, description
                  )
           VALUES (l_display_name, program_owner_in, program_name_in
                 , overload_in, description_in
                  );
END;