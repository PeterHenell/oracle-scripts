@@bidir.pks
@@bidir.pkb

DECLARE
   l_row   employee%ROWTYPE;
BEGIN
   employee_bidir.goto_first_row;

   WHILE employee_bidir.row_found
   LOOP
      l_row := employee_bidir.current_row;
      DBMS_OUTPUT.put_line (l_row.last_name);
      employee_bidir.goto_next_row;
   END LOOP;
   
   employee_bidir.goto_last_row;

   WHILE employee_bidir.row_found
   LOOP
      l_row := employee_bidir.current_row;
      DBMS_OUTPUT.put_line (l_row.last_name);
      employee_bidir.goto_previous_row;
   END LOOP;   
END;
/
