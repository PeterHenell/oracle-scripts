/* This does not work. 
   What is the correct type for COLLECT? 
*/
   
CREATE OR REPLACE TYPE strings_t IS TABLE OF VARCHAR2 (100)
/

DECLARE
   n   strings_t;
BEGIN
   SELECT COLLECT (last_name) INTO n FROM employees;

   DBMS_OUTPUT.put_line (n.COUNT);
END;
/