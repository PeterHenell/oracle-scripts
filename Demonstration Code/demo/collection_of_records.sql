DECLARE
   CURSOR all_emps_cur
   IS
      SELECT * FROM employees;

   /* A collection type each of whose elements has the
      same structure as a row in the employees table,
      indexed by integer */
   TYPE employees_aat IS TABLE OF employees%ROWTYPE
                            INDEX BY PLS_INTEGER;

   l_employees           employees_aat;

   /* A collection type each of whose elements has the
      same structure as a row in the employees table,
      indexed by the last name. */
   TYPE employees_by_name_aat IS TABLE OF employees%ROWTYPE
                                    INDEX BY employees.last_name%TYPE;

   l_employees_by_name   employees_by_name_aat;

   /* You can use your own customer record type as well. */
   TYPE two_columns_rt IS RECORD
   (
      employee_id   employees.employee_id%TYPE
    , salary        employees.salary%TYPE
   );

   TYPE id_name_list_tt IS TABLE OF two_columns_rt
                              INDEX BY PLS_INTEGER;
BEGIN
   /* Programatic manipulation */
   l_employees (77).last_name := 'FEUERSTEIN';
   l_employees.delete (77);

   /* Populate the collection sequentially, starting from 1.
      Generic formula for adding sequentially....
   */
   FOR employee_rec IN (SELECT * FROM employees)
   LOOP
      l_employees (l_employees.COUNT + 1) := employee_rec;
   END LOOP;

   DBMS_OUTPUT.put_line (
         'Sequential LAST and COUNT = '
      || TO_CHAR (l_employees.LAST)
      || '-'
      || TO_CHAR (l_employees.COUNT));

   /* Populate the collection sequentially, using the
      ROWCOUNT attribute from the cursor....
   */

   FOR employee_rec IN all_emps_cur
   LOOP
      l_employees (all_emps_cur%ROWCOUNT) := employee_rec;
   END LOOP;

   /* Reference fields in each record (element of collection) as
      you would with a record variable.

      In the following line of code I overwrite the existing last
      name for the first employee loaded into the collection
      with my name.
   */

   l_employees (l_employees.FIRST).last_name := 'Feuerstein';

   DBMS_OUTPUT.put_line (
         'Sequential with ROWCOUNT LAST and COUNT = '
      || TO_CHAR (l_employees.LAST)
      || '-'
      || TO_CHAR (l_employees.COUNT));

   /* Now fill the collection NON-sequentially, using the
      index value to emulate the primary key. */
   l_employees.delete;

   FOR employee_rec IN (SELECT * FROM employees)
   LOOP
      l_employees (employee_rec.employee_id) := employee_rec;
   END LOOP;

   DBMS_OUTPUT.put_line (
         'Primary key LAST and COUNT = '
      || TO_CHAR (l_employees.LAST)
      || '-'
      || TO_CHAR (l_employees.COUNT));

   DBMS_OUTPUT.put_line (
      'Direct access to employee 138: ' || l_employees (138).last_name);

   /* Now fill the collection NON-sequentially, using the
   index value to emulate the last name unique index. */
   FOR employee_rec IN (SELECT * FROM employees)
   LOOP
      l_employees_by_name (employee_rec.last_name) := employee_rec;
   END LOOP;

   DBMS_OUTPUT.put_line (
         'Last Name LAST and COUNT = '
      || l_employees_by_name.LAST
      || '-'
      || l_employees_by_name.COUNT);
      
   DBMS_OUTPUT.put_line (
      'Direct access to employee with last name Stiles: '
      || l_employees_by_name ('Stiles').employee_id);
   
   /* Programmatic checking for duplicates....
   
   FOR employee_rec IN (SELECT * FROM employees)
   LOOP
      IF l_employees_by_name.EXISTS (employee_rec.last_name)
      THEN
         DBMS_OUTPUT.put_line (
            'Duplicate last name! ' || employee_rec.last_name);
      ELSE
         l_employees_by_name (employee_rec.last_name) := employee_rec;
      END IF;
   END LOOP;
   
   */         
END;
/