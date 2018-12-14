CREATE OR REPLACE FUNCTION employee_names
   RETURN sys_refcursor
IS
   l_return sys_refcursor;
BEGIN
   OPEN l_return FOR
      SELECT last_name, first_name
        FROM employees;

   RETURN l_return;
END employee_names;
/

DECLARE
   TYPE name_rt IS RECORD (
      first_name employees.first_name%TYPE
    , last_name employees.last_name%TYPE
   );

   l_record name_rt;
   l_names_cur sys_refcursor;
BEGIN
   DBMS_OUTPUT.put_line ( 'List of employees using cursor FOR loop...' );
   l_names_cur := employee_names();

   LOOP
      FETCH l_names_cur
       INTO l_record;

      EXIT WHEN l_names_cur%NOTFOUND;
      DBMS_OUTPUT.put_line (    'Employee name = '
                             || l_record.first_name
                             || ' '
                             || l_record.last_name
                           );
   END LOOP;

   CLOSE l_names_cur;
END;
/

DECLARE
   TYPE name_rt IS RECORD (
      first_name employees.first_name%TYPE
    , last_name employees.last_name%TYPE
   );

   TYPE name_array_t IS TABLE OF name_rt
      INDEX BY PLS_INTEGER;

   l_names_array name_array_t;
   l_names_cur sys_refcursor;
BEGIN
   DBMS_OUTPUT.put_line ( 'List of employees using BULK COLLECT...' );
   l_names_cur := employee_names;

   FETCH l_names_cur
   BULK COLLECT INTO l_names_array;

   CLOSE l_names_cur;

   FOR indx IN 1 .. l_names_array.COUNT
   LOOP
      DBMS_OUTPUT.put_line (    'Employee name = '
                             || l_names_array ( indx ).first_name
                             || ' '
                             || l_names_array ( indx ).last_name
                           );
   END LOOP;
END;
/
