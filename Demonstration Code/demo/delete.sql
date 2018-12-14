DECLARE
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
                            INDEX BY PLS_INTEGER;

   l_employees   employees_aat;
BEGIN
   SELECT *
     BULK COLLECT INTO l_employees
     FROM employees;

   -- Delete just the first row.
   l_employees.delete (l_employees.FIRST);
   --
   -- Delete all rows between 7 and 20.
   l_employees.delete (7, 20);

   --
   -- Delete all the even rows (!).
   FOR indx IN 1 .. l_employees.COUNT
   LOOP
      IF l_employees.EXISTS (indx) AND MOD (indx, 2) = 0
      THEN
         l_employees.delete (indx);
      END IF;
   END LOOP;

   -- Delete all the remaining rows.
   l_employees.delete;
END;
/

/* Try to delete from a varray */

DECLARE
   TYPE employees_va IS VARRAY (5) OF employees%ROWTYPE;

   l_varray      employees_va;
BEGIN
   SELECT *
     BULK COLLECT INTO l_varray
     FROM employees;

   l_varray.delete (10);
END;
/