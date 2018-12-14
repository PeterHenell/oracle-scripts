CREATE OR REPLACE PACKAGE ibtab
IS
   FUNCTION rowval (indx IN PLS_INTEGER) RETURN DATE;
   PRAGMA RESTRICT_REFERENCES (rowval, WNPS, WNDS);
END;
/
CREATE OR REPLACE PACKAGE BODY ibtab
IS
   TYPE date_tab IS TABLE OF DATE INDEX BY BINARY_INTEGER;
   hiredates date_tab;

   FUNCTION rowval (indx IN PLS_INTEGER) RETURN DATE
   IS BEGIN
      RETURN hiredates (indx);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN RETURN NULL;
   END;
BEGIN
   FOR rec IN (SELECT employee_id, hire_date FROM employee)
   LOOP
      hiredates(rec.employee_id) := rec.hire_date;
   END LOOP;
END;
/

SELECT last_name, ibtab.rowval (employee_id) Date_from_IBTab
  FROM employee
 ORDER BY last_name;
