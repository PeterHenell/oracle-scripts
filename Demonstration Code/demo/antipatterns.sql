/* Context switching reduction */

CREATE OR REPLACE FUNCTION plch_total_compensation (
   salary_in           IN NUMBER,
   commission_pct_in   IN NUMBER)
   RETURN NUMBER
IS
BEGIN
   RETURN NVL (commission_pct_in, 0) + salary_in;
END;
/

CREATE OR REPLACE FUNCTION plch_emp_comp (
   employee_id_in   IN INTEGER)
   RETURN NUMBER
IS
   l_return   NUMBER;
BEGIN
   SELECT plch_total_compensation (salary, commission_pct)
     INTO l_return
     FROM plch_employees;

   RETURN l_return;
END;
/

SELECT plch_emp_comp (employee_id) total_comp
  FROM plch_employees
/

-- Rewrite #1 - 0 context switches

SELECT NVL (commission_pct, 0) + salary total_comp
  FROM plch_employees
/

-- Rewrite #2 - reduced code in 12.1

CREATE OR REPLACE FUNCTION plch_total_compensation (
   salary_in           IN NUMBER,
   commission_pct_in   IN NUMBER)
   RETURN NUMBER
IS
   PRAGMA UDF;
BEGIN
   RETURN NVL (commission_pct_in, 0) + salary_in;
END;
/

SELECT plch_total_compensation (salary, commission_pct)
          total_comp
  FROM plch_employees
/

/*
1.    Optimizing SQL in PL/SQL

- SQL first, PL/SQL second
- Loops with DML

*/

/* Nested loops */

CREATE OR REPLACE PROCEDURE plch_lucky_employees (
   department_name_in   IN plch_departments.department_name%TYPE,
   last_name_like_in    IN VARCHAR2)
IS
BEGIN
   FOR drec IN (SELECT *
                  FROM plch_departments
                 WHERE department_name = department_name_in)
   LOOP
      FOR erec IN (  SELECT *
                       FROM plch_employees
                      WHERE department_id = drec.department_id
                   ORDER BY last_name)
      LOOP
         IF erec.last_name LIKE last_name_like_in
         THEN
            UPDATE plch_employees
               SET salary = salary * 2
             WHERE employee_id = erec.employee_id;
         END IF;
      END LOOP;
   END LOOP;
END;
/

-- rewrite 4203

CREATE OR REPLACE PROCEDURE plch_lucky_employees (
   department_name_in   IN plch_departments.department_name%TYPE,
   last_name_like_in    IN VARCHAR2)
IS
BEGIN
   UPDATE plch_employees
      SET salary = salary * 2
    WHERE     department_id =
                 (SELECT department_id
                    FROM plch_departments
                   WHERE department_name = department_name_in)
          AND last_name LIKE last_name_like_in;
END;
/

/* Logic in PL/SQL, should be in SQL */

CREATE OR REPLACE FUNCTION plch_senior_employee (
   employee_id_in   IN INTEGER)
   RETURN BOOLEAN
IS
   l_salary      plch_employees.salary%TYPE;
   l_hire_date   plch_employees.hire_date%TYPE;
BEGIN
   SELECT hire_date, salary
     INTO l_hire_date, l_salary
     FROM plch_employees
    WHERE employee_id = employee_id_in;

   RETURN     l_hire_date < ADD_MONTHS (SYSDATE, -10 * 12)
          AND l_salary > 10000;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN FALSE;
END;
/

-- rewrite 7950

CREATE OR REPLACE FUNCTION plch_senior_employee (
   employee_id_in   IN INTEGER)
   RETURN BOOLEAN
IS
   l_count   INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM plch_employees
    WHERE     employee_id = employee_id_in
          AND hire_date < ADD_MONTHS (SYSDATE, -10 * 12)
          AND salary > 10000;

   RETURN l_count = 1;
END;
/

/* One two three function calls */

CREATE OR REPLACE FUNCTION plch_salary (
   employee_id_in   IN INTEGER)
   RETURN NUMBER
IS
   l_return   NUMBER;
BEGIN
   SELECT salary
     INTO l_return
     FROM plch_employees
    WHERE employee_id = employee_id_in;

   RETURN l_return;
END;
/

CREATE OR REPLACE FUNCTION plch_last_name (
   employee_id_in   IN INTEGER)
   RETURN VARCHAR2
IS
   l_return   plch_employees.last_name%TYPE;
BEGIN
   SELECT last_name
     INTO l_return
     FROM plch_employees
    WHERE employee_id = employee_id_in;

   RETURN l_return;
END;
/

CREATE OR REPLACE PROCEDURE plch_show_info (
   employee_id_in   IN INTEGER)
IS
   l_name     plch_employees.last_name%TYPE;
   l_salary   plch_employees.salary%TYPE;
BEGIN
   l_name := plch_last_name (employee_id_in);
   l_salary := plch_salary (employee_id_in);
   DBMS_OUTPUT.put_line (l_name || ' earns ' || l_salary);
END;
/

-- rewrite NNNNN

CREATE OR REPLACE PROCEDURE plch_show_info (
   employee_id_in   IN INTEGER)
IS
   l_name     plch_employees.last_name%TYPE;
   l_salary   plch_employees.salary%TYPE;
BEGIN
   SELECT last_name, salary
     INTO l_name, l_salary
     FROM plch_employees
    WHERE employee_id = employee_id_in;

   DBMS_OUTPUT.put_line (l_name || ' earns ' || l_salary);
END;
/

-- ? Drop functions?

/* BULK COLLECT anti-patterns */

DECLARE
   CURSOR emps_cur
   IS
      SELECT *
        FROM plch_employees
       WHERE department_id = 50;

   l_row   emps_cur%ROWTYPE;
BEGIN
   OPEN emps_cur;

   LOOP
      FETCH emps_cur INTO l_row;

      EXIT WHEN emps_cur%NOTFOUND;
      DBMS_OUTPUT.put_line (l_row.last_name);
   END LOOP;

   CLOSE emps_cur;
END;
/

-- Rewrite #1: cursor FOR loop!

BEGIN
   FOR l_row IN (SELECT *
                   FROM plch_employees
                  WHERE department_id = 50)
   LOOP
      DBMS_OUTPUT.put_line (l_row.last_name);
   END LOOP;
END;
/

-- Rewrite #2: BULK COLLECT it!

DECLARE
   CURSOR emps_cur
   IS
      SELECT *
        FROM plch_employees
       WHERE department_id = 50;

   TYPE emps_t IS TABLE OF emps_cur%ROWTYPE;

   l_emps   emps_t;
BEGIN
   OPEN emps_cur;

   FETCH emps_cur BULK COLLECT INTO l_emps;

   CLOSE emps_cur;

   FOR indx IN 1 .. l_emps.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_row.last_name);
   END LOOP;
END;
/

DECLARE
   CURSOR emps_cur
   IS
      SELECT *
        FROM plch_employees
       WHERE department_id = 50;

   TYPE emps_t IS TABLE OF emps_cur%ROWTYPE;

   l_emps   emps_t;
BEGIN
   OPEN emps_cur;

   FETCH emps_cur BULK COLLECT INTO l_emps;

   CLOSE emps_cur;

   FOR indx IN 1 .. l_emps.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_row.last_name);
   END LOOP;
END;
/

/* BULK COLLECT - limit clause */

CREATE OR REPLACE PROCEDURE plch_do_stuff (
   emp_in   IN emps_cur%ROWTYPE)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      emp_in.employee_id || '-' || emp_in.last_name);
END;
/

DECLARE
   CURSOR emps_cur
   IS
      SELECT * FROM plch_employees;

   TYPE emps_t IS TABLE OF emps_cur%ROWTYPE;

   l_emps   emps_t;
BEGIN
   OPEN emps_cur;

   FETCH emps_cur BULK COLLECT INTO l_emps;

   CLOSE emps_cur;

   FOR indx IN 1 .. l_emps.COUNT
   LOOP
      plch_do_stuff (l_emps (indx));
   END LOOP;
END;
/

-- Rewrite #1 - with HARD-CODED limit

DECLARE
   CURSOR emps_cur
   IS
      SELECT * FROM plch_employees;

   TYPE emps_t IS TABLE OF emps_cur%ROWTYPE;

   l_emps   emps_t;
BEGIN
   OPEN emps_cur;

   LOOP
      FETCH emps_cur BULK COLLECT INTO l_emps LIMIT 100;

      FOR indx IN 1 .. l_emps.COUNT
      LOOP
         plch_do_stuff (l_emps (indx));
      END LOOP;
      
      EXIT WHEN emps_cur%NOTFOUND;
   END LOOP;

   CLOSE emps_cur;
END;
/

-- Rewrite #2 - with SOFT-CODED limit

CREATE OR REPLACE PACKAGE plch_config
IS
   c_bulk_limit   CONSTANT PLS_INTEGER := 100;
END;
/

DECLARE
   CURSOR emps_cur
   IS
      SELECT * FROM plch_employees;

   TYPE emps_t IS TABLE OF emps_cur%ROWTYPE;

   l_emps   emps_t;
BEGIN
   OPEN emps_cur;

   LOOP
      FETCH emps_cur
         BULK COLLECT INTO l_emps
         LIMIT plch_pkg.c_bulk_limit;

      FOR indx IN 1 .. l_emps.COUNT
      LOOP
         plch_do_stuff (l_emps (indx));
      END LOOP;

      EXIT WHEN emps_cur%NOTFOUND;
   END LOOP;

   CLOSE emps_cur;
END;
/

/* FORALL */

/* Loop with single DML */

/* FORALL with some errors */

/* FORALL with gaps */

/* FORALL with two DML statements */

/*
2. Caching data

- PGA
- FRC
- Deterministic

*/

/*
3. Hard-coding/Repetition

- Literal
- Declaration
- Formula
*/

/*
4. Error Management

*/