DECLARE
   e_value_too_big   EXCEPTION;
   PRAGMA EXCEPTION_INIT (e_value_too_big, -1438);
BEGIN
   BEGIN
      UPDATE employees
         SET salary = salary * 10000;
   EXCEPTION
      WHEN e_value_too_big
      THEN
         DBMS_OUTPUT.put_line ('That is one heck of a salary increase!');
      WHEN OTHERS
      THEN
         log_error ();
         RAISE;
   END;

   /* This technique works for any kind of exception, not just those
      raised from the SQL layer. */
   DECLARE
      l_old       NUMBER := 10000;
      l_divisor   NUMBER := 0;
      l_new       NUMBER;
   BEGIN
      l_new := l_old / l_divisor;
   EXCEPTION
      WHEN OTHERS
      THEN
         log_error ();
   END;

   ROLLBACK;
END;
/