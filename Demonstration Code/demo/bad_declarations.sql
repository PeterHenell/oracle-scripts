DECLARE
   l_last_name    VARCHAR2 (100);
   l_full_name    VARCHAR2 (500);
   l_big_string   VARCHAR2 (32767);
BEGIN
   SELECT last_name, last_name || ', ' || first_name full_name
     INTO l_last_name, l_full_name
     FROM employee
    WHERE employee_id = 1500;
--
-- Lots more code....
END;