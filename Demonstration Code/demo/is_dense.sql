/* Is a collection densely filled? */

DECLARE
   /* A collection type each of whose elements has the
      same structure as a row in the employees table,
      indexed by integer */
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
                            INDEX BY PLS_INTEGER;

   l_employees   employees_aat;
BEGIN
   IF l_employees.COUNT = l_employees.LAST - l_employees.FIRST + 1
   THEN
      DBMS_OUTPUT.put_line ('No gaps!');
   END IF;
END;