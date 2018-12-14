CREATE TABLE omag_employees
(
   employee_id   INTEGER PRIMARY KEY,
   last_name     VARCHAR2 (100),
   salary        NUMBER
)
/

BEGIN
   INSERT INTO omag_employees
        VALUES (100, 'Rockwell', 1000);

   INSERT INTO omag_employees
        VALUES (200, 'Picasso', 2000);

   INSERT INTO omag_employees
        VALUES (300, 'Van Gogh', 3000);

   COMMIT;
END;
/

SELECT employee_id, last_name, salary
  FROM omag_employees
/

BEGIN
   FOR employee_rec
      IN (SELECT employee_id,
                 last_name,
                 salary
            FROM omag_employees)
   LOOP
      DBMS_OUTPUT.put_line (
            employee_rec.employee_id
         || '-'
         || employee_rec.last_name);
   END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE process_employee (
   employee_id_in IN omag_employees.employee_id%TYPE)
IS
   l_employee_id   omag_employees.employee_id%TYPE;
   l_last_name     omag_employees.last_name%TYPE;
   l_salary        omag_employees.salary%TYPE;
BEGIN
   SELECT employee_id,
          last_name,
          salary
     INTO l_employee_id,
          l_last_name,
          l_salary
     FROM omag_employees
    WHERE employee_id = Employee_id_in;
END;
/

CREATE OR REPLACE PROCEDURE process_employee (
   employee_id_in IN omag_employees.employee_id%TYPE)
IS
   l_employee   omag_employees%ROWTYPE;
BEGIN
   SELECT employee_id,
          last_name,
          salary
     INTO l_employee
     FROM omag_employees
    WHERE employee_id = Employee_id_in;
END;
/

DECLARE
   CURSOR no_ids_cur
   IS
      SELECT last_name, salary
        FROM omag_employees;

   l_employee   no_ids_cur%ROWTYPE;
BEGIN
   OPEN no_ids_cur;

   FETCH no_ids_cur INTO l_employee;

   CLOSE no_ids_cur;
END;
/

DECLARE
   l_employee   omag_employees%ROWTYPE;
BEGIN
   EXECUTE IMMEDIATE
      'SELECT * FROM omag_employees'
      INTO l_employee;
END;
/

DECLARE
   l_employee   omag_employees%ROWTYPE;
BEGIN
   l_employee.last_name := 'Renoir';
   l_employee.salary := 1500;
END;
/

DECLARE
   l_old_employee   omag_employees%ROWTYPE;
   l_new_employee   omag_employees%ROWTYPE;
BEGIN
   l_new_employee := l_old_employee;
   l_old_employee := NULL;
END;
/

CREATE TABLE omag_employees2
(
   employee_id   INTEGER PRIMARY KEY,
   last_name     VARCHAR2 (100),
   salary        NUMBER
)
/

DECLARE
   l_old_employee   omag_employees%ROWTYPE;
   l_new_employee   omag_employees2%ROWTYPE;
BEGIN
   l_new_employee := l_old_employee;
   l_old_employee := NULL;
END;
/

CREATE OR REPLACE PROCEDURE show_employee (
   employee_id_in   IN omag_employees.employee_id%TYPE,
   last_name_in     IN omag_employees.last_name%TYPE,
   salary_in        IN omag_employees.salary%TYPE)
IS
BEGIN
   DBMS_OUTPUT.put_line (
         employee_id_in
      || '-'
      || last_name_in
      || '-'
      || salary_in);
END;
/

CREATE OR REPLACE PROCEDURE show_employee (
   employee_in IN omag_employees%ROWTYPE)
IS
BEGIN
   DBMS_OUTPUT.put_line (
         employee_in.employee_id
      || '-'
      || employee_in.last_name
      || '-'
      || employee_in.salary);
END;
/

DECLARE
   l_employee_id   omag_employees.employee_id%TYPE
      := 500;
   l_last_name     omag_employees.last_name%TYPE
      := 'Mondrian';
   l_salary        omag_employees.salary%TYPE
      := 2000;
BEGIN
   INSERT
     INTO omag_employees (employee_id,
                          last_name,
                          salary)
   VALUES (
             l_employee_id,
             l_last_name,
             l_salary);
END;
/

DECLARE
   l_employee   omag_employees%ROWTYPE;
BEGIN
   l_employee.employee_id := 500;
   l_employee.last_name := 'Mondrian';
   l_employee.salary := 2000;

   INSERT INTO omag_employees
        VALUES l_employee;
END;
/

/* Update with record */

DECLARE
   l_employee   omag_employees%ROWTYPE;
BEGIN
   l_employee.employee_id := 500;
   l_employee.last_name := 'Mondrian';
   l_employee.salary := 2000;

   UPDATE omag_employees
      SET row = l_employee
    WHERE employee_id = 100;
END;
/

DECLARE
   l_name1           VARCHAR2 (100);
   l_total_sales1    NUMBER;
   l_deliver_pref1   VARCHAR2 (10);
   --
   l_name2           VARCHAR2 (100);
   l_total_sales2    NUMBER;
   l_deliver_pref2   VARCHAR2 (10);
BEGIN
   NULL;
END;
/

DECLARE
   TYPE customer_info_rt IS RECORD
   (
      name           VARCHAR2 (100),
      total_sales    NUMBER,
      deliver_pref   VARCHAR2 (10)
   );

   l_customer1   customer_info_rt;
   l_customer2   customer_info_rt;
BEGIN
   NULL;
END;
/

DECLARE
   TYPE user_preferences_rt IS RECORD
   (
      show_full_name   BOOLEAN,
      autologin        BOOLEAN
   );

   l_user   user_preferences_rt;
BEGIN
   NULL;
END;
/

/* Nested record */

DECLARE
   TYPE phone_rectype IS RECORD
   (
      area_code    PLS_INTEGER,
      exchange     PLS_INTEGER,
      phn_number   PLS_INTEGER,
      extension    PLS_INTEGER
   );

   TYPE contact_rectype IS RECORD
   (
      day_phone#    phone_rectype,
      eve_phone#    phone_rectype,
      cell_phone#   phone_rectype
   );

   l_sales_rep   contact_rectype;
BEGIN
   /* Set the day phone # */
   l_sales_rep.day_phone#.area_code :=
      773;
   l_sales_rep.day_phone#.exchange :=
      426;
   l_sales_rep.day_phone#.phn_number :=
      9093;
   l_sales_rep.day_phone#.extension :=
      NULL;

   /* Copy day phone to evening phone */
   l_sales_rep.eve_phone# :=
      l_sales_rep.day_phone#;

   /* "Override" just phn_number field. */
   l_sales_rep.eve_phone#.phn_number :=
      2056;
END;
/

/* Pseudorecords in triggers */

CREATE OR REPLACE TRIGGER 
   omag_employees_freeze_trg
   BEFORE INSERT
   ON omag_employees
   FOR EACH ROW
DECLARE
BEGIN
   IF :NEW.salary > :OLD.salary
   THEN
      RAISE_APPLICATION_ERROR (
         -20000,
         'Salary freeze in effect: '||
         ' no increases allowed!');
   END IF;
END omag_employees_freeze_trg;
/

/* Clean up */

DROP TABLE omag_employees
/

DROP TABLE omag_employees2
/