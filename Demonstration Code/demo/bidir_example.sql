CREATE OR REPLACE PROCEDURE bidir_example
IS
   TYPE employee_tt IS TABLE OF employee%ROWTYPE
      INDEX BY PLS_INTEGER;

   employee_cache   employee_tt;
   l_row            PLS_INTEGER;
BEGIN
   SELECT *
   BULK COLLECT INTO employee_cache
     FROM employee;

   DBMS_OUTPUT.put_line ('From first to last...');
   l_row := employee_cache.FIRST;

   WHILE (l_row IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line ('   ' || employee_cache (l_row).last_name);
      l_row := employee_cache.NEXT (l_row);
   END LOOP;

   DBMS_OUTPUT.put_line ('From last to first...');
   l_row := employee_cache.LAST;

   WHILE (l_row IS NOT NULL)
   LOOP
      DBMS_OUTPUT.put_line ('   ' || employee_cache (l_row).last_name);
      l_row := employee_cache.PRIOR (l_row);
   END LOOP;

   DBMS_OUTPUT.put_line ('Compare fifth row to twelfth row...');

   IF employee_cache (5).salary > employee_cache (12).salary
   THEN
      DBMS_OUTPUT.put_line ('   Fifth row salary greater than twelfth.');
   ELSE
      DBMS_OUTPUT.put_line ('   Fifth row salary is not greater than twelfth.');
   END IF;

   employee_cache.DELETE;
END bidir_example;
/
