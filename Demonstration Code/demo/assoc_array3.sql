SET SERVEROUTPUT ON
SET TIMING ON

DECLARE
   TYPE tab_bynum_tabtype IS TABLE OF employee%ROWTYPE
      INDEX BY BINARY_INTEGER;

   bynum_tab tab_bynum_tabtype;
   
   v_salary NUMBER;
BEGIN
   FOR rec IN  (SELECT *
                  FROM employee)
   LOOP
      bynum_tab (rec.employee_id) := rec;
   END LOOP;

   FOR indx IN 1 .. 10000
   LOOP
      FOR rec IN  (SELECT *
                     FROM employee)
      LOOP
         v_salary := bynum_tab (rec.employee_id).salary;
      END LOOP;
   END LOOP;


END;
/

DECLARE
   TYPE tab_byvc_tabtype IS TABLE OF employee%ROWTYPE
      INDEX BY VARCHAR2(100);
   
   byvc_tab tab_byvc_tabtype;
   
   v_salary NUMBER;
BEGIN
   FOR rec IN  (SELECT *
                  FROM employee)
   LOOP
      byvc_tab (rec.last_name) := rec;
   END LOOP;

   FOR indx IN 1 .. 10000
   LOOP
      FOR rec IN  (SELECT *
                     FROM employee)
      LOOP
         v_salary := byvc_tab (rec.last_name).salary;
      END LOOP;
   END LOOP;
END;
/