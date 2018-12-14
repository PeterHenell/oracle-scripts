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