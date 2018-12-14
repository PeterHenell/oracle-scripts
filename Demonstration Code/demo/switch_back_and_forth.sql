CREATE OR REPLACE FUNCTION full_name (first_in   IN VARCHAR2,
                                      last_in    IN VARCHAR2)
   RETURN VARCHAR2
IS
BEGIN
   RETURN first_in || ' ' || last_in;
END;
/

CREATE OR REPLACE FUNCTION emp_name (employee_id_in IN INTEGER)
   RETURN VARCHAR2
IS
   l_return   VARCHAR2 (32767);
BEGIN
   SELECT full_name (first_name, last_name) INTO l_return FROM employees;

   RETURN l_return;
END;
/

SELECT emp_name (employee_id) FROM employees
/