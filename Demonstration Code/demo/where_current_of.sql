DROP TABLE plch_employees
/

CREATE TABLE plch_employees
(
   employee_id   INTEGER
 ,  last_name     VARCHAR2 (100)
 ,  salary        NUMBER
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

DECLARE
   CURSOR emps_cur
   IS
      SELECT *
        FROM plch_employees
      FOR UPDATE;

   l_count   PLS_INTEGER := 0;
BEGIN
   FOR rec IN emps_cur
   LOOP
      DELETE FROM plch_employees
            WHERE CURRENT OF emps_cur;

      l_count := l_count + SQL%ROWCOUNT;
   END LOOP;

   DBMS_OUTPUT.put_line (l_count);
   ROLLBACK;
END;
/

DECLARE
   CURSOR emps_cur
   IS
      SELECT *
        FROM plch_employees
      FOR UPDATE;

   l_count   PLS_INTEGER := 0;
BEGIN
   FOR rec IN emps_cur
   LOOP
      DELETE FROM emps_cur
            WHERE CURRENT OF;

      l_count := l_count + SQL%ROWCOUNT;
   END LOOP;

   DBMS_OUTPUT.put_line (l_count);
   ROLLBACK;
END;
/

DECLARE
   l_count   PLS_INTEGER := 0;
BEGIN
   FOR rec IN (SELECT *
                 FROM plch_employees
               FOR UPDATE)
   LOOP
      DELETE FROM plch_employees
            WHERE CURRENT OF SQL%CURRENT_CURSOR;

      l_count := l_count + SQL%ROWCOUNT;
   END LOOP;

   DBMS_OUTPUT.put_line (l_count);
   ROLLBACK;
END;
/

DECLARE
   CURSOR emps_cur
   IS
      SELECT *
        FROM plch_employees
      FOR UPDATE;

   l_employee   emps_cur%ROWTYPE;

   l_count      PLS_INTEGER := 0;
BEGIN
   OPEN emps_cur;

   LOOP
      FETCH emps_cur INTO l_employee;

      EXIT WHEN emps_cur%NOTFOUND;

      DELETE FROM plch_employees
            WHERE CURRENT OF emps_cur;

      l_count := l_count + SQL%ROWCOUNT;
   END LOOP;

   DBMS_OUTPUT.put_line (l_count);
   ROLLBACK;
END;
/

/* But cannot use it with returning! */

DECLARE
   CURSOR emps_cur
   IS
      SELECT *
        FROM plch_employees
      FOR UPDATE;

   l_count   PLS_INTEGER := 0;
   EmpId plch_employees.employee_id%TYPE ;
   
BEGIN
   FOR rec IN emps_cur
   LOOP
      DELETE FROM plch_employees
            WHERE CURRENT OF emps_cur      
            RETURNING employee_id INTO EmpId;

      l_count := l_count + SQL%ROWCOUNT;
   END LOOP;

   DBMS_OUTPUT.put_line (l_count);
   ROLLBACK;
END;