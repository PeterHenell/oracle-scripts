CREATE OR REPLACE TRIGGER EMPLOYEES_bir
  BEFORE INSERT ON EMPLOYEES
  FOR EACH ROW
DECLARE
BEGIN
  IF :NEW.EMPLOYEE_ID IS NULL
  THEN
    :NEW.EMPLOYEE_ID := EMPLOYEES_CP.next_key;
  END IF;
END EMPLOYEES_bir;
/
