DECLARE
   TYPE employees_t IS TABLE OF employees%ROWTYPE;

   l_employees   employees_t;
BEGIN
     -- All rows at once...
     SELECT *
       BULK COLLECT INTO l_employees
       FROM employees
   ORDER BY last_name DESC;

   DBMS_OUTPUT.put_line (l_employees.COUNT);

   FOR indx IN 1 .. l_employees.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_employees (indx).last_name);
   END LOOP;
END;
/

/* Roughly equivalent with opt level 2 or higher */

BEGIN
   FOR rec IN (  SELECT *
                   FROM employees
               ORDER BY last_name DESC)
   LOOP
      DBMS_OUTPUT.put_line (l_employees (indx).last_name);
   END LOOP;
END;
/

/* And this algorithm will NOT be automatically optimized */

DECLARE
   CURSOR employees_cur
   IS
        SELECT *
          BULK COLLECT INTO l_employees
          FROM employees
      ORDER BY last_name DESC;

   l_employee   employees_cur%ROWTYPE;
BEGIN
   OPEN employees_cur;

   LOOP
      FETCH employees_cur INTO l_employee;

      EXIT WHEN employees_cur%NOTFOUND;
      DBMS_OUTPUT.put_line (l_employee.last_name);
   END LOOP;
END;
/