DROP TRIGGER employees_too_young_tr
/

CREATE TABLE our_employees
(
   last_name       VARCHAR2 (100)
 , date_of_birth   DATE
)
/

CREATE OR REPLACE TRIGGER employees_too_young_tr
   AFTER INSERT OR UPDATE
   ON our_employees
   FOR EACH ROW
BEGIN
   IF :new.date_of_birth > ADD_MONTHS (SYSDATE, -12 * 18)
   THEN
      RAISE_APPLICATION_ERROR (-20000, 'Employee must be 18');
   END IF;
END employees_too_young_tr;
/

BEGIN
   INSERT INTO our_employees
        VALUES ('Feuerstein', SYSDATE);
END;
/

CREATE OR REPLACE TRIGGER employees_too_young_tr
   AFTER INSERT OR UPDATE
   ON our_employees
   FOR EACH ROW
BEGIN
   IF :new.date_of_birth > ADD_MONTHS (SYSDATE, -12 * 18)
   THEN
      DBMS_STANDARD.RAISE_APPLICATION_ERROR (-20000, 'Employee must be 18');
   END IF;
END employees_too_young_tr;
/

BEGIN
   INSERT INTO our_employees
        VALUES ('Feuerstein', SYSDATE);
END;
/

CREATE OR REPLACE TRIGGER employees_too_young_tr
   AFTER INSERT OR UPDATE
   ON our_employees
   FOR EACH ROW
BEGIN
   IF :new.date_of_birth > ADD_MONTHS (SYSDATE, -12 * 18)
   THEN
      RAISE (-20000, 'Employee must be 18');
   end if;
end employees_too_young_tr;
/

BEGIN
   INSERT INTO our_employees
        VALUES ('Feuerstein', SYSDATE);
END;
/

CREATE OR REPLACE TRIGGER employees_too_young_tr
   AFTER INSERT OR UPDATE
   ON our_employees
   FOR EACH ROW
BEGIN
   IF :new.date_of_birth > ADD_MONTHS (SYSDATE, -12 * 18)
   THEN
      RAISE 'Employee must be 18';
   END IF;
END employees_too_young_tr;
/

BEGIN
   INSERT INTO our_employees
        VALUES ('Feuerstein', SYSDATE);
END;
/

CREATE OR REPLACE TRIGGER employees_too_young_tr
   AFTER INSERT OR UPDATE
   ON our_employees
   FOR EACH ROW
BEGIN
   IF :new.date_of_birth > ADD_MONTHS (SYSDATE, -12 * 18)
   THEN
      DECLARE
         e_too_young EXCEPTION;
      BEGIN
         RAISE e_too_young;
      END;
   END IF;
END employees_too_young_tr;
/

BEGIN
   INSERT INTO our_employees
        VALUES ('Feuerstein', SYSDATE);
END;
/