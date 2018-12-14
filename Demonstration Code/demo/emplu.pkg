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
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE;

   FUNCTION onerow_incremental (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE;

   PROCEDURE clear_cache;

   PROCEDURE load_cache;
END;
/

CREATE OR REPLACE PACKAGE BODY emplu2
IS
   c_limit          CONSTANT PLS_INTEGER DEFAULT 1000;

   TYPE employee_tt
   IS
      TABLE OF employees%ROWTYPE
         INDEX BY PLS_INTEGER;

   employee_cache   employee_tt;

   PROCEDURE clear_cache
   IS
   BEGIN
      employee_cache.delete;
   END;

   -- Assumes entire table is already loaded into the collection.
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE
   IS
   BEGIN
      RETURN employee_cache (employee_id_in);
   END onerow;

   -- Loads the cache as each row is queried/needed.
   -- Minimizes need to query row a second time in session.
   FUNCTION onerow_incremental (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE
   IS
      retval   employees%ROWTYPE;
   BEGIN
      IF employee_cache.EXISTS (employee_id_in)
      THEN
         retval := employee_cache (employee_id_in);
      ELSE
         SELECT *
           INTO retval
           FROM employees
          WHERE employee_id = employee_id_in;

         /* TC Oct 2008 - don't let the cache get too big! */
         IF employee_cache.COUNT > c_limit
         THEN
            employee_cache.delete;
         END IF;

         employee_cache (employee_id_in) := retval;
      END IF;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END onerow_incremental;

   PROCEDURE load_cache
   IS
   BEGIN
      FOR rec IN ( SELECT *
                     FROM employees )
      LOOP
         employee_cache (rec.employee_id) := rec;
      END LOOP;
   END load_cache;
BEGIN
   load_cache;
END emplu2;
/

CREATE OR REPLACE PACKAGE emplu3
IS
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE;

   FUNCTION onerow (last_name_in IN employees.last_name%TYPE)
      RETURN employees%ROWTYPE;
END;
/

CREATE OR REPLACE PACKAGE BODY emplu3
IS
   TYPE employee_tt
   IS
      TABLE OF employees%ROWTYPE
         INDEX BY PLS_INTEGER;

   TYPE employees_by_name_tt
   IS
      TABLE OF employees%ROWTYPE
         INDEX BY employees.last_name%TYPE;

   employee_cache            employee_tt;
   employee_by_names_cache   employees_by_name_tt;

   -- Assumes entire table is already loaded into the collection.
   FUNCTION onerow (employee_id_in IN employees.employee_id%TYPE)
      RETURN employees%ROWTYPE
   IS
   BEGIN
      RETURN employee_cache (employee_id_in);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN emplu1.onerow (employee_id_in);
   END onerow;

   FUNCTION onerow (last_name_in IN employees.last_name%TYPE)
      RETURN employees%ROWTYPE
   IS
   BEGIN
      RETURN employee_by_names_cache (last_name_in);
   END onerow;

   PROCEDURE load_cache
   IS
      /* Zagreb Sept 2007 - move temp cache to local procedure. */
      temp_employee_cache   employee_tt;
   BEGIN
      /* In two steps:
      1. Use BULK COLLECT to retrieve data rapidly.
      2. Move from sequential to primary key-indexed collection.
      */

      /* Cartesian product! Just to prove point about efficiency
                                 of collection manipulation. */
      SELECT e1.*
        BULK COLLECT
        INTO temp_employee_cache
        FROM employees, employees e1;

      DBMS_OUTPUT.put_line (
         'emplu3 Loaded into temporary cache = ' || temp_employee_cache.COUNT
      );

      FOR l_row IN 1 .. temp_employee_cache.COUNT
      LOOP
         employee_cache (temp_employee_cache (l_row).employee_id) :=
            temp_employee_cache (l_row);
         employee_by_names_cache (temp_employee_cache (l_row).last_name) :=
            temp_employee_cache (l_row);
      END LOOP;
   END load_cache;
BEGIN
   load_cache;
END emplu3;
/