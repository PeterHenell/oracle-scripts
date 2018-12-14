REM drop table lots_of_employees;
REM drop table employee_history;

CREATE TABLE lots_of_employees (
        employee_id             NUMBER(10),
        last_name               VARCHAR2(15),
        first_name              VARCHAR2(15),
        middle_initial          VARCHAR2(1),
        job_id                  NUMBER(3),
        manager_id              NUMBER(4),
        hire_date               DATE DEFAULT SYSDATE NOT NULL,
        salary                  NUMBER(7,2),
        commission              NUMBER(7,2),
        department_id           NUMBER(10)
        );

create unique index un_employee_id ON lots_of_employees (employee_id);

create index in_employee_department ON lots_of_employees (department_id);
	
CREATE TABLE employee_history (
        employee_id             NUMBER(4),
        hire_date               DATE DEFAULT SYSDATE NOT NULL,
        salary                  NUMBER(7,2)  ,
        activity VARCHAR2(100)
        );

CREATE OR REPLACE PROCEDURE load_employee (
   first_in IN PLS_INTEGER
 , last_in IN PLS_INTEGER
)
IS
-- Put lots of rows into the table
   maxnum PLS_INTEGER;
BEGIN
   FOR indx IN first_in .. last_in
   LOOP
      SELECT MAX (employee_id)
        INTO maxnum
        FROM lots_of_employees;

      INSERT INTO lots_of_employees
                  (employee_id, last_name, first_name
                 , salary, department_id, hire_date
                  )
           VALUES (maxnum + 1, 'Feuerstein' || indx, 'Steven'
                 , indx, MOD (indx, 4) * 10, SYSDATE
                  );

      IF MOD (indx, 1000) = 0
      THEN
         COMMIT;
      END IF;
   END LOOP;

   COMMIT;
END;
/