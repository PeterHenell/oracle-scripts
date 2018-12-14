CREATE OR REPLACE FUNCTION apply_cola (salary_in IN NUMBER)
   RETURN NUMBER
IS
BEGIN
   RETURN salary_in * 2;
END;
/

/* This will only work in Oracle11g */

DECLARE
   TYPE two_columns_rt IS RECORD (
      employee_id   employees.employee_id%TYPE
    , salary        employees.salary%TYPE
   );
   
   TYPE id_name_list_tt IS TABLE OF two_columns_rt INDEX BY PLS_INTEGER;
   
   l_list   id_name_list_tt;
BEGIN
   SELECT employee_id, salary
   BULK COLLECT INTO l_list FROM employees;

   FOR idx IN 1 .. l_list.COUNT LOOP
      l_list (idx).salary := apply_cola (l_list (idx).salary);
   END LOOP;

   FORALL idx IN 1 .. l_list.COUNT
      UPDATE employees SET salary = l_list (idx).salary
       WHERE employee_id = l_list (idx).employee_id;
       
   ROLLBACK;       
END;
/

/* Row level operations will work in 10g */

DECLARE
   TYPE employees_t IS TABLE OF employees%ROWTYPE INDEX BY PLS_INTEGER;
   l_employees  employees_t;
BEGIN
   SELECT *
   BULK COLLECT INTO l_employees FROM employees;

   FOR idx IN 1 .. l_employees.COUNT LOOP
      l_employees (idx).salary := apply_cola (l_employees (idx).salary);
   END LOOP;

   FORALL idx IN 1 .. l_employees.COUNT
      UPDATE employees SET ROW = l_employees (idx)
       WHERE employee_id = 138;
      
   DELETE FROM employees;
       
   FORALL idx IN 1 .. l_employees.COUNT
      INSERT INTO employees VALUES l_employees (idx);
       
   ROLLBACK;       
END;
/