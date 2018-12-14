DROP TABLE my_employees
/

CREATE TABLE my_employees
(
   employee_name   VARCHAR2 (100)
 , birth_date      DATE
)
/

CREATE OR REPLACE TRIGGER employee_must_be_18_tr
   BEFORE INSERT OR UPDATE
   ON my_employees
   FOR EACH ROW
BEGIN
   IF :new.birth_date > ADD_MONTHS (SYSDATE, -1 * 18 * 12)
   THEN
      raise_application_error (-20070, 'Employee must be 18.');
   END IF;
END employee_must_be_18_tr;
/

BEGIN
   INSERT INTO my_employees
        VALUES ('Steven Feuerstein', SYSDATE);
EXCEPTION
   WHEN OTHERS
   THEN
      log_error ();
      RAISE;
END;
/

/*
ORA-20070: Employee must be 18.
ORA-06512: at "HR.EMPLOYEE_MUST_BE_18_TR", line 4
ORA-04088: error during execution of trigger 'HR.EMPLOYEE_MUST_BE_18_TR'
ORA-06512: at line 2
*/