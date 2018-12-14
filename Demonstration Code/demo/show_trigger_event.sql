CREATE OR REPLACE PROCEDURE show_trigger_event
IS
BEGIN
   DBMS_OUTPUT.put_line (CASE
                            WHEN UPDATING THEN 'UPDATE'
                            WHEN INSERTING THEN 'INSERT'
                            WHEN DELETING THEN 'DELETE'
                            else 'Procedure not executed from DML trigger!'
                         END);
END;
/

DROP TRIGGER employee_changes1
/

CREATE OR REPLACE TRIGGER employee_changes
   AFTER UPDATE OR INSERT
   ON employees
BEGIN
   show_trigger_event;
END;
/

BEGIN
   show_trigger_event;

   UPDATE employees
      SET last_name = last_name;

   ROLLBACK;
END;
/