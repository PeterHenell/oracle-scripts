DROP TABLE err$_employees
/

DROP PACKAGE elp$_employees
/

BEGIN
   dbms_errlog_helper.create_objects ('EMPLOYEES');
/*
After running this, check out the ELP$_EMPLOYEES package
*/
END;
/

/* Update with LOG ERRORS */

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

   SELECT COUNT ( * )
     INTO l_count
     FROM employees
    WHERE salary > 24000;

   DBMS_OUTPUT.put_line ('After ' || l_count);

   ROLLBACK;
END;
/

/*
Use the objects created by the helper utility.
*/

DECLARE
   l_errors   elp$_employees.error_log_tc;
BEGIN
   l_errors := elp$_employees.error_log_contents;

   FOR indx IN 1 .. l_errors.COUNT
   LOOP
      DBMS_OUTPUT.put_line (
         l_errors (indx).ora_err_mesg$ || ' - ' || l_errors (indx).last_name
      );
   END LOOP;
END;
/