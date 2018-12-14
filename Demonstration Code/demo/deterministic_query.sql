CREATE OR REPLACE FUNCTION employee_name (
   employee_id_in   IN   employees.employee_id%TYPE
)
   RETURN VARCHAR2 DETERMINISTIC
IS
   retval VARCHAR2 ( 100 );
BEGIN
   SELECT last_name
     INTO retval
     FROM employees
    WHERE employee_id = employee_id_in;

   RETURN retval;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
END;
/

/* The deterministic caching does not carry over from
   one query to the next. */

DECLARE
   l_string employees.last_name%TYPE;
BEGIN
   SELECT employee_name ( 135 )
     INTO l_string
     FROM DUAL;

   p.l ( l_string );

   UPDATE employees
      SET last_name = 'Feuerstein'
    WHERE employee_id = 135;

   SELECT employee_name ( 135 )
     INTO l_string
     FROM DUAL;

   p.l ( l_string );
   ROLLBACK;
END;
/
