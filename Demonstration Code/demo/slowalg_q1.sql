DECLARE
   CURSOR emp_cur
   IS
      SELECT last_name, TO_CHAR (SYSDATE, 'MM/DD/YYYY') today
        FROM employee;
BEGIN
   FOR rec IN emp_cur
   LOOP
      IF LENGTH (rec.last_name) > 20
      THEN
         rec.last_name := SUBSTR (rec.last_name, 1, 20);
      END IF;
      process_employee_history (rec.last_name, today);
   END LOOP;
END;
/