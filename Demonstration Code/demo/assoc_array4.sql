SET SERVEROUTPUT ON
SET TIMING ON

DECLARE
   TYPE name_t IS TABLE OF employee%ROWTYPE
      INDEX BY employee.last_name%TYPE;

   TYPE id_t IS TABLE OF employee%ROWTYPE
      INDEX BY employee.employee_id%TYPE;
      -- Won't work: INDEX BY employee.employee_id%TYPE;
	  -- Inconsistent with BINARY_INTEGER as root type.

   by_name   name_t;
   by_id     id_t;

   PROCEDURE load_arrays
   IS
   BEGIN
      FOR rec IN  (SELECT *
                     FROM employee)
      LOOP
         by_name (rec.last_name) := rec;
         by_id (rec.employee_id) := rec;
      END LOOP;
   END;
BEGIN
   load_arrays;

   -- Now I can retrieve information by name or ID:
   
   IF by_name ('SMITH').salary > by_id(7645).salary
   THEN
      null;
   END IF;
END;
/

