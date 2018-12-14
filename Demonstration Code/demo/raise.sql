DECLARE
   e_bad_date_format   EXCEPTION;
   PRAGMA EXCEPTION_INIT (e_bad_date_format, -1830);

   l_id                PLS_INTEGER;

   PROCEDURE log_error
   IS
   BEGIN
      sys.DBMS_OUTPUT.put_line (SQLCODE);
   END;
BEGIN
   /* Oracle raises a NDF exception */
   SELECT employee_id
     INTO l_id
     FROM employees
    WHERE 1 = 2;

   /* Raise a pre-defined exception */
   RAISE NO_DATA_FOUND;

   /* Raise a user-defined exception */
   RAISE e_bad_date_format;
EXCEPTION
   WHEN OTHERS
   THEN
      log_error ();
      --RAISE;
END;
/