/* Demonstration of how an error in any row forces rollback of entire
   DML statement - even rows that were successfully modified are 
   rolled back.
*/

/* First show that there are employees who could have their salary 
   multipled by 200 - nice raise! 
*/

DECLARE
   l_salary   employees.salary%TYPE;
BEGIN
   FOR rec IN (SELECT * FROM employees)
   LOOP
      BEGIN
         l_salary := rec.salary * 200;
         DBMS_OUTPUT.put_line ('New salary = ' || l_salary);
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
      END;
   END LOOP;
END;
/

/* Now try to update all employees with single DML statement. */

DECLARE
   l_count   PLS_INTEGER;
BEGIN
   SELECT COUNT (*)
     INTO l_count
     FROM employees
    WHERE salary > 24000;

   DBMS_OUTPUT.put_line ('Before ' || l_count);

   UPDATE employees
      SET salary = salary * 200;

   SELECT COUNT (*)
     INTO l_count
     FROM employees
    WHERE salary > 24000;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);

      SELECT COUNT (*)
        INTO l_count
        FROM employees
       WHERE salary > 24000;

      DBMS_OUTPUT.put_line ('After ' || l_count);
END;
/