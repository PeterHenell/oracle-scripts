
--Write an anonymous block that copies all the employee last names 
--from the employees table to an associative array based on that column.

--After the collection has been filled, use FORALL to delete all 

DECLARE
   TYPE v_ass_arr IS TABLE OF employees.last_name%TYPE
      INDEX BY PLS_INTEGER;

   emp_tab v_ass_arr;
   j PLS_INTEGER;
BEGIN
   SELECT last_name
   BULK COLLECT INTO emp_tab
     FROM employees;

   DBMS_OUTPUT.put_line ( 'count:' || emp_tab.COUNT );
   --
   FORALL i IN 1 .. emp_tab.COUNT
      DELETE      employees
            WHERE last_name = emp_tab ( i );
   DBMS_OUTPUT.put_line ( SQL%ROWCOUNT || ' records deleted.' );

   SELECT COUNT ( * )
     INTO j
     FROM employees;

   DBMS_OUTPUT.put_line ( '1. count:' || j );
   ROLLBACK;

   FOR i IN 1 .. emp_tab.COUNT
   LOOP
      DELETE      employees
            WHERE last_name = emp_tab ( i );
   END LOOP;

   SELECT COUNT ( * )
     INTO j
     FROM employees;

   DBMS_OUTPUT.put_line ( '2. count:' || j );
END;

ROLLBACK ;
