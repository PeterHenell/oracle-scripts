/* Different table in each one, so the choices can
   be verified independently. */
   
/* Two sets of local variables, two queries
   differing only by format and variables. */
   
CREATE TABLE my_employees
(
   employee_id     INTEGER
 , last_name       VARCHAR2 (100)
 , salary          NUMBER
)
/

CREATE OR REPLACE PROCEDURE run_queries
IS
   l_salary    INTEGER := 10;
   l_name    VARCHAR2 (100) := 'S%';
   l_salary2   INTEGER := 10;
   l_name2   VARCHAR2 (100) := 'S%';
BEGIN
   FOR rec IN (select last_name, salary
                 from my_employees
                where salary = l_salary 
                  and last_name like l_name)
   LOOP
      NULL;
   END LOOP;
   
   FOR rec IN (SELECT ename, sal
                 FROM my_employees
                WHERE last_name LIKE 'S%' AND salary = 10)
   LOOP
      NULL;
   END LOOP;

   FOR rec IN (SELECT last_name, salary
                 FROM MY_EMPLOYEES
       WHERE salary = l_salary2 AND last_name LIKE l_name2)
   LOOP
      NULL;
   END LOOP;
END;
/

BEGIN
   run_queries;
END;
/   

SELECT sql_text
  FROM v$sqlarea a
 WHERE     UPPER (sql_text) LIKE '%FROM MY_EMPLOYEES%'
       AND UPPER (sql_text) NOT LIKE '%V$SQLAREA%'
/

drop TABLE my_employees
/