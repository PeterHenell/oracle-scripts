CREATE OR REPLACE TRIGGER are_you_too_young
   AFTER insert OR update 
   ON employee FOR EACH ROW
BEGIN
   IF :new.date_of_birth > ADD_MONTH (SYSDATE, -12 * 18)
   THEN
      RAISE_APPLICATION_ERROR (
         -20070, 'You have to be 18');
   END IF;
END;
/


