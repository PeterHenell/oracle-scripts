CREATE TABLE temp_emp (employee_id NUMBER
   , last_name VARCHAR2(100)
   , extra DATE DEFAULT SYSDATE)
/

DECLARE
   TYPE r IS RECORD (
      n   NUMBER
    , v   VARCHAR2 (1000)
   );

   TYPE t IS TABLE OF r;

   rr   t := t ();
BEGIN
   rr (1).n := 1000;
   rr (1).v := 'STEVEN';
   --
   FORALL indx IN rr.FIRST .. rr.LAST
      INSERT INTO temp_emp
                  (employee_id, last_name)
           VALUES rr (indx);
END;