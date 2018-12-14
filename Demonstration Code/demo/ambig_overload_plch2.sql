DROP TABLE plch_employees
/

CREATE TABLE plch_employees
(
   employee_id     INTEGER
 , last_name       VARCHAR2 (100)
 , salary          NUMBER
 , department_id   INTEGER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100
              , 'Jobs'
              , 1000000
              , 100);

   INSERT INTO plch_employees
        VALUES (200
              , 'Ellison'
              , 1000000
              , 200);

   INSERT INTO plch_employees
        VALUES (300
              , 'Gates'
              , 1000000
              , 200);

   COMMIT;
END;
/

CREATE OR REPLACE PACKAGE plch_pkg
IS
   SUBTYPE currency_t IS NUMBER (10, 2);

   SUBTYPE currency_desc_t IS VARCHAR2 (100);

   FUNCTION total_salary (department_id_in IN INTEGER)
      RETURN currency_t;

   FUNCTION total_salary (department_id_in IN INTEGER)
      RETURN currency_desc_t;
END;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   FUNCTION total_salary (department_id_in IN INTEGER)
      RETURN currency_t
   IS
      l_total   currency_t;
   BEGIN
      SELECT SUM (salary)
        INTO l_total
        FROM plch_employees e
       WHERE e.department_id = total_salary.department_id_in;

      RETURN l_total;
   END;

   FUNCTION total_salary (department_id_in IN INTEGER)
      RETURN currency_desc_t
   IS
      l_total   currency_t;
   BEGIN
      SELECT SUM (salary)
        INTO l_total
        FROM plch_employees e
       WHERE e.department_id = total_salary.department_id_in;

      RETURN TO_CHAR (l_total, 'FML999G999G999');
   END;
END;
/

DECLARE
   l_total_salary        plch_pkg.currency_t;
   l_total_salary_desc   plch_pkg.currency_desc_t;
BEGIN
   l_total_salary := plch_pkg.total_salary (200);
   l_total_salary_desc := plch_pkg.total_salary (200);
   DBMS_OUTPUT.put_line (l_total_salary_desc);
END;
/

DECLARE
   l_total_salary_desc   plch_pkg.currency_desc_t;
BEGIN
   l_total_salary_desc := plch_pkg.total_salary (200);
   DBMS_OUTPUT.put_line (l_total_salary_desc);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (plch_pkg.total_salary (200));
END;
/

DECLARE
   l_total_salary        NUMBER;
   l_total_salary_desc   VARCHAR2 (100);
BEGIN
   l_total_salary := plch_pkg.total_salary (200);
   l_total_salary_desc := plch_pkg.total_salary (200);
   DBMS_OUTPUT.put_line (l_total_salary_desc);
END;
/