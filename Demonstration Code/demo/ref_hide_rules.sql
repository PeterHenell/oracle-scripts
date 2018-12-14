-- exposed rules. bad news.

PROCEDURE insert_employee (rec_in IN employee%ROWTYPE)
IS
BEGIN
   IF rec_in.hiredate > ADD_MONTHS (SYSDATE, -1 * 18 * 12)
   THEN
      notify_employee_too_young;
   ELSIF rec_in.citizen_ID IS NULL
   THEN
      notify_no_citizen_ID;
   ELSIF rec_in.citizen_ID NOT LIKE '___-__-____'
   THEN
      notify_bad_citizen_ID;
   ELSE
      perform_insert (rec_in);
   END IF;
END insert_employee;

-- create a container for the rules

CREATE OR REPLACE PACKAGE employee_rp
IS
   FUNCTION too_young (hiredate_in IN DATE)
      RETURN BOOLEAN;

   FUNCTION citizen_ID_not_null (citizen_ID_in IN VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION valid_citizen_ID (citizen_ID_in IN VARCHAR2)
      RETURN BOOLEAN;
END employee_rp;
/

-- rebuild the program with the rules functions

PROCEDURE insert_employee (rec_in IN employee%ROWTYPE)
IS
BEGIN
   IF employee_rp.too_young (rec_in.hiredate)
   THEN
      notify_employee_too_young;
   ELSIF employee_rp.citizen_ID_not_null (rec_in.citizen_ID)
   THEN
      notify_no_citizen_ID;
   ELSIF NOT employee_rp.valid_citizen_ID (rec_in.citizen_ID)
   THEN
      notify_bad_citizen_ID;
   ELSE
      perform_insert (rec_in);
   END IF;
END insert_employee;
/

