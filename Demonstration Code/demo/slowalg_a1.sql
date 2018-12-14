CREATE OR REPLACE PACKAGE today
IS
   FUNCTION without_time RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (without_time, WNPS, WNDS);
END;
/
CREATE OR REPLACE PACKAGE BODY today
IS
   g_today VARCHAR2(10) :=  TO_CHAR (SYSDATE, 'MM/DD/YYYY');
   
   FUNCTION without_time RETURN VARCHAR2
      IS BEGIN RETURN g_today; END;
END;
/
   
DECLARE
   v_today CONSTANT VARCHAR2(10) := today.without_time;
   
   -- This makes sense ONLY if calling SUBSTR for each row
   -- is faster than calling LENGTH for each, and then 
   -- SUBSTR only when needed!
   CURSOR emp_cur
   IS
      SELECT SUBSTR (last_name, 1, 20) last_name FROM employee;
BEGIN
   FOR rec IN emp_cur
   LOOP
      process_employee_history (rec.last_name, v_today);
   END LOOP;
END;
/

or in 81/9i...

DECLARE
   v_today   CONSTANT VARCHAR2 (10) := today.without_time;

   TYPE last_name_tt IS TABLE OF employee.last_name%TYPE
      INDEX BY BINARY_INTEGER;

   last_names         last_name_tt;
BEGIN
   SELECT SUBSTR (last_name, 1, 20) last_name
   BULK COLLECT INTO last_names
     FROM employee;

   FOR indx IN last_names.FIRST .. last_names.LAST
   LOOP
      process_employee_history (last_names (indx), v_today);
   END LOOP;
END;
/