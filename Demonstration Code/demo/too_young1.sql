CREATE TABLE my_employee (
   name VARCHAR2(100),
   date_of_birth DATE)
/

CREATE OR REPLACE TRIGGER are_you_old_enough
   AFTER insert OR update 
   ON my_employee FOR EACH ROW
BEGIN
   IF :new.date_of_birth > ADD_MONTHS (SYSDATE, -12 * 18)
   THEN
      RAISE_APPLICATION_ERROR (
         -20773, 'You must be at least 18 years of age to work here.');
   END IF;
END;
/
