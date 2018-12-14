/* 
Demonstrate benefits of non-sequential indexing:

Compare performance of looking up data in table each time
vs
Cache data in a collection using the primary key as the index.

Step 1. Create the packages.

*/

CREATE OR REPLACE PACKAGE emplu1
IS
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE;
END;
/

CREATE OR REPLACE PACKAGE BODY emplu1
IS
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE
   IS
      onerow_rec   employees%ROWTYPE;
   BEGIN
      SELECT * 
        INTO onerow_rec
        FROM employees
       WHERE employee_id = employee_id_in;

      RETURN onerow_rec;
   END;
END;
/

CREATE OR REPLACE PACKAGE emplu2
IS
   TYPE employee_tt IS TABLE OF employees%ROWTYPE
                          INDEX BY PLS_INTEGER;

   employee_cache   employee_tt;

   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE;
END;
/

CREATE OR REPLACE PACKAGE BODY emplu2
IS
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE
   IS
   BEGIN
      RETURN employee_cache (employee_id_in);
   END onerow;
BEGIN
   FOR rec IN (SELECT *
                 FROM employees)
   LOOP
      employee_cache (rec.employee_id) := rec; 
   END LOOP;
END emplu2;
/
