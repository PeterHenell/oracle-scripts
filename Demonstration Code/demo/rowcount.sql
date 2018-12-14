DROP TABLE plch_employees
/

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 ,  salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (138, 10000);

   INSERT INTO plch_employees
        VALUES (140, 10000);

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE show_rowcount (text_in IN VARCHAR2)
IS
BEGIN
   DBMS_OUTPUT.put_line (
      'SQL%ROWCOUNT for "' || text_in || '" = ' || SQL%ROWCOUNT);
END;
/

DECLARE
   CURSOR emps_c
   IS
      SELECT * FROM plch_employees;

   emps_r      emps_c%ROWTYPE;
   l_emp_ids   DBMS_SQL.number_table;

   PROCEDURE give_raise_at (id_in IN INTEGER, amount_in IN NUMBER)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE plch_employees
         SET salary = salary + amount_in
       WHERE employee_id = id_in;

      show_rowcount ('After update in AT');
      COMMIT;
      show_rowcount ('After commit in AT');
   END;
BEGIN
   show_rowcount ('Before any SQL statements executed');

   UPDATE plch_employees
      SET employee_id = -1 * employee_id;

   show_rowcount ('After update');
   COMMIT;
   show_rowcount ('After commit');

   give_raise_at (-138, 40000);

   FOR rec IN (SELECT * FROM plch_employees)
   LOOP
      show_rowcount ('Inside CFL');
   END LOOP;

   OPEN emps_c;

   LOOP
      FETCH emps_c INTO emps_r;

      show_rowcount ('Inside explicit loop');
      EXIT WHEN emps_c%NOTFOUND;
   END LOOP;

   show_rowcount ('After explicit loop');

   SELECT employee_id
     BULK COLLECT INTO l_emp_ids
     FROM plch_employees;

   show_rowcount ('After BULK COLLECT');
END;
/

/* Another exerciser for ROWCOUNT */

DECLARE
   l_count   PLS_INTEGER;
BEGIN
   plch_show_rowcount ('nothing');

   COMMIT;

   plch_show_rowcount ('post commit');

   SELECT COUNT (*) INTO l_count FROM plch_employees;

   plch_show_rowcount ('count query');
END;
/

/*
If a SELECT INTO statement without a BULK COLLECT clause returns multiple rows, 
PL/SQL raises the predefined exception TOO_MANY_ROWS and SQL%ROWCOUNT returns 1, 
not the actual number of rows that satisfy the query

Which of these shows display 1?
*/

DROP TABLE plch_employees
/

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 ,  salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (138, 10000);

   INSERT INTO plch_employees
        VALUES (140, 10000);

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE show_rowcount
IS
BEGIN
   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

DECLARE
   l_salary   plch_employees.salary%TYPE;
BEGIN
   SELECT salary INTO l_salary FROM plch_employees;

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

DECLARE
   l_salary   plch_employees.salary%TYPE;
BEGIN
   SELECT salary
     INTO l_salary
     FROM plch_employees
    WHERE employee_id = 138;

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/

DECLARE
   l_count   PLS_INTEGER;
BEGIN
   SELECT COUNT (*) INTO l_count FROM plch_employeesl_count;

   DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQL%ROWCOUNT);
END;
/