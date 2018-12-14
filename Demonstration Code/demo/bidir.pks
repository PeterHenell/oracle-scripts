CREATE OR REPLACE PACKAGE employee_bidir
IS
   PROCEDURE set_row (
      index_in IN PLS_INTEGER
   );

   FUNCTION current_row
      RETURN employee%ROWTYPE;

   PROCEDURE goto_first_row;

   PROCEDURE goto_last_row;

   PROCEDURE goto_next_row;

   PROCEDURE goto_previous_row;

   FUNCTION row_found
      RETURN BOOLEAN;

   PROCEDURE load_cache;
END employee_bidir;
/
