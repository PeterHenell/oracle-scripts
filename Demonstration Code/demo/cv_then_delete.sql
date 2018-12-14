CREATE OR REPLACE PROCEDURE get_employees (CV OUT sys_refcursor)
IS
BEGIN
   OPEN CV FOR
      SELECT *
        FROM employees;

   DELETE FROM employees;
END;
/

DECLARE
   CV        sys_refcursor;
   r         employees%ROWTYPE;
   l_count   PLS_INTEGER := 0;
BEGIN
   get_employees (CV);

   LOOP
      FETCH CV INTO r;

      EXIT WHEN CV%NOTFOUND;
      l_count := l_count + 1;
   END LOOP;

   DBMS_OUTPUT.put_line ('Employee count via CV: ' || l_count);

   SELECT COUNT ( * )
     INTO l_count
     FROM employees;

   DBMS_OUTPUT.put_line ('Employee count via direct query: ' || l_count);


   CLOSE CV;

   ROLLBACK;
/*
Employee count via CV: 107
Employee count via direct query: 0
*/
END;
/

/* Now with explicit cursor */

DECLARE
   CURSOR CV
   IS
      SELECT *
        FROM employees;

   r         employees%ROWTYPE;
   l_count   PLS_INTEGER := 0;
BEGIN
   OPEN CV;

   DELETE FROM employees;

   LOOP
      FETCH CV INTO r;

      EXIT WHEN CV%NOTFOUND;
      l_count := l_count + 1;
   END LOOP;

   DBMS_OUTPUT.put_line ('Employee count via CV: ' || l_count);

   SELECT COUNT ( * )
     INTO l_count
     FROM employees;

   DBMS_OUTPUT.put_line ('Employee count via direct query: ' || l_count);


   CLOSE CV;

   ROLLBACK;
/*
Employee count via CV: 107
Employee count via direct query: 0
*/
END;
/