DECLARE
   TYPE namelist_t IS TABLE OF VARCHAR2 (1000)
      INDEX BY BINARY_INTEGER;

   enames   namelist_t;
BEGIN
   enames (1) := 'steven';
   enames (100) := 'feuerstein';
   FORALL indx IN enames.FIRST .. enames.LAST
      UPDATE employee
         SET salary = 10000
       WHERE last_name = enames (indx);
END;
/