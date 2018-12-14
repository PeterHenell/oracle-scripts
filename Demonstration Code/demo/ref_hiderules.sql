Step 1 Hide business rules inside functions (PL/SQL refactoring)

Step 1 in the refactoring of topic "Hide business rules inside functions"

Universal ID = {AF727C21-7F1F-4BD5-9F15-A924F516245E}

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
================================================================================
Step 2 Hide business rules inside functions (PL/SQL refactoring)

Step 2 in the refactoring of topic "Hide business rules inside functions"

Universal ID = {3E1C1FCF-889F-450B-838E-DBF72BAE937A}

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
================================================================================
Step 0: Problematic code for  Hide business rules inside functions (PL/SQL refactoring) 

The problematic code for that demonstrates "Hide business rules inside function
ns (PL/SQL refactoring)"

Universal ID = {1C5974A6-AC59-4276-B6FF-370CFC2D059C}

PROCEDURE insert_employee (rec_in IN employee%ROWTYPE)
IS
   l_results   qnr.name_resolve_rt;
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
================================================================================
