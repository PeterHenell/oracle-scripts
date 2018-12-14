DROP TABLE plch_employees
/

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 , last_name     VARCHAR2 (100)
 , salary        NUMBER
)
/

BEGIN
   INSERT INTO plch_employees
        VALUES (100, 'Jobs', 1000000);

   INSERT INTO plch_employees
        VALUES (200, 'Ellison', 1000000);

   INSERT INTO plch_employees
        VALUES (300, 'Gates', 1000000);

   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE busy_procedure (
   employee_id_in IN plch_employees.employee_id%TYPE)
IS
   l_employee        plch_employees%ROWTYPE;
   l_line            VARCHAR2 (1023);
   l_file            UTL_FILE.file_type;
   l_list_of_names   DBMS_SQL.varchar2s;
BEGIN
   BEGIN
      SELECT *
        INTO l_employee
        FROM plch_employees e
       WHERE e.employee_id = employee_id_in;

      DBMS_OUTPUT.put_line ('Last Name = ' || l_employee.last_name);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLERRM);
   END;

   BEGIN
      l_file := UTL_FILE.fopen ('TEMP', 'plch_employees.txt', 'R');
      UTL_FILE.get_line (l_file, l_line);
      UTL_FILE.get_line (l_file, l_line);
      DBMS_OUTPUT.put_line (l_line);
      UTL_FILE.fclose (l_file);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLERRM);
   END;

   BEGIN
        SELECT last_name
          BULK COLLECT INTO l_list_of_names
          FROM plch_employees
      ORDER BY last_name;

      IF l_list_of_names (100) = 'Jobs'
      THEN
         DBMS_OUTPUT.put_line ('A hard worker!');
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLERRM);
   END;
END busy_procedure;
/

BEGIN
   busy_procedure (400);
END;
/