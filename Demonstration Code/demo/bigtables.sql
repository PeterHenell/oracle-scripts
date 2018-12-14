DROP TABLE employee_big;
DROP TABLE department_big;
CREATE TABLE employee_big AS SELECT * FROM employee;
ALTER TABLE employee_big MODIFY employee_id NUMBER;
ALTER TABLE employee_big MODIFY salary NUMBER;

DECLARE
-- Put lots of rows into the table
   maxnum   PLS_INTEGER;
BEGIN
   FOR indx IN 1 .. 100000
   LOOP
      SELECT MAX (employee_id)
        INTO maxnum
        FROM employee_big;

      INSERT INTO employee_big
                  (employee_id, last_name, first_name, salary
                 , department_id, hire_date, created_by, created_on
                 , changed_by, changed_on
                  )
           VALUES (maxnum + 1, 'Feuerstein' || indx, 'Steven', indx
                 , MOD (indx, 4) * 10, SYSDATE, USER, SYSDATE
                 , USER, SYSDATE
                  );

      IF MOD (indx, 10000) = 0
      THEN
         COMMIT;
      END IF;
   END LOOP;
END;
/

CREATE INDEX i_emp2_dept ON employee_big (department_id, salary);
CREATE TABLE department_big AS SELECT * FROM department;