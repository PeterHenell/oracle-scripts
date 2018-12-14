DROP TABLE err$_employees
/

BEGIN
   DBMS_ERRLOG.create_error_log (dml_table_name => 'EMPLOYEES' /* Optional override of log table name, really only
                                                                  needed if your table name is > 25 characters in length:
                                                                  , err_log_table_name      => 'override'*/
                                                              );
END;
/

DESC ERR$_EMPLOYEES

/*
Now let's try to do an update with some bad data.

First, without LOG ERRORS....
*/

DECLARE
   l_count   PLS_INTEGER;
BEGIN
   SELECT COUNT ( * )
     INTO l_count
     FROM employees
    WHERE salary > 24000;

   DBMS_OUTPUT.put_line ('Before ' || l_count);

   UPDATE employees
      SET salary = salary * 200;

   SELECT COUNT ( * )
     INTO l_count
     FROM employees
    WHERE salary > 24000;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);

      SELECT COUNT ( * )
        INTO l_count
        FROM employees
       WHERE salary > 24000;

      DBMS_OUTPUT.put_line ('After ' || l_count);
END;
/

/* And now with LOG ERRORS */

DECLARE
   l_count   PLS_INTEGER;
BEGIN
   SELECT COUNT ( * )
     INTO l_count
     FROM employees
    WHERE salary > 24000;

   DBMS_OUTPUT.put_line ('Before ' || l_count);

       UPDATE employees
          SET salary = salary * 200
   LOG ERRORS REJECT LIMIT UNLIMITED;

   DBMS_OUTPUT.put_line ('After 1 ' || SQL%ROWCOUNT);

   SELECT COUNT ( * )
     INTO l_count
     FROM employees
    WHERE salary > 24000;

   DBMS_OUTPUT.put_line ('After 2 ' || l_count);

   ROLLBACK;
END;
/

SELECT 'Number of errors = ' || COUNT ( * )
  FROM err$_employees
/

SELECT ora_err_mesg$, last_name
  FROM err$_employees
/

BEGIN
   DELETE FROM err$_employees;

   COMMIT;
END;
/

/* Try to triple the size of the first name
   and allow no more than 10 errors. */

BEGIN
       UPDATE employees
          SET first_name = first_name || first_name || first_name
   LOG ERRORS REJECT LIMIT 10;

   ROLLBACK;
END;
/

SELECT 'Number of errors = ' || COUNT ( * )
  FROM err$_employees
/
