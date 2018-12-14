/* Formatted on 2002/04/25 18:42 (Formatter Plus v4.6.6) */
CREATE OR REPLACE PROCEDURE check_age (
   dob_in   IN   DATE
)
IS
BEGIN
   IF dob_in > add_month (SYSDATE, -12 * 18)
   THEN
      errpkg.RAISE (errpkg.en_min_age_violated);
   END IF;
END;
/

CREATE OR REPLACE TRIGGER validate_employee_changes
   AFTER INSERT OR UPDATE
   ON employee
   FOR EACH ROW
BEGIN
   check_age (:NEW.date_of_birth);
   check_resume (:NEW.RESUME);
END;

