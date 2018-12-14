CREATE OR REPLACE FUNCTION fullname ( l IN VARCHAR2, f IN VARCHAR2 )
   RETURN VARCHAR2
IS
BEGIN
   RETURN l || ',' || f;
END fullname;
/

CREATE OR REPLACE FUNCTION max_salary ( job_in IN VARCHAR2 )
   RETURN NUMBER
IS
BEGIN
   RETURN 25000;
END max_salary;
/

CREATE OR REPLACE PACKAGE fullname_pkg
IS
   FUNCTION fullname ( l IN VARCHAR2, f IN VARCHAR2 )
      RETURN VARCHAR2;

   FUNCTION max_salary ( job_in IN VARCHAR2 )
      RETURN NUMBER;
END fullname_pkg;
/

CREATE OR REPLACE PACKAGE BODY fullname_pkg
IS
   FUNCTION fullname ( l IN VARCHAR2, f IN VARCHAR2 )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN l || ',' || f;
   END fullname;

   FUNCTION max_salary ( job_in IN VARCHAR2 )
      RETURN NUMBER
   IS
   BEGIN
      RETURN 25000;
   END max_salary;
END fullname_pkg;
/

DECLARE
   l_counter PLS_INTEGER := 1000;
   l_start_time NUMBER;
   l_name VARCHAR2 ( 32767 );

   PROCEDURE show_elapsed ( string_in IN VARCHAR2 )
   IS
   BEGIN
      DBMS_OUTPUT.put_line (    'Elapsed time for "'
                             || string_in
                             || '" = '
                             || TO_CHAR (   (   DBMS_UTILITY.get_cpu_time
                                              - l_start_time
                                            )
                                          / 100
                                        )
                             || ' seconds.'
                           );
   END show_elapsed;
BEGIN
   DBMS_OUTPUT.put_line ( l_counter || ' Iterations' );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR i IN 1 .. l_counter
   LOOP
      SELECT last_name || ',' || first_name
        INTO l_name
        FROM employees
       WHERE employee_id = 137;
   END LOOP;

   show_elapsed ( 'No function in select list' );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR i IN 1 .. l_counter
   LOOP
      SELECT fullname ( last_name, first_name )
        INTO l_name
        FROM employees
       WHERE employee_id = 137;
   END LOOP;

   show_elapsed ( 'Schema-level function in select list' );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR i IN 1 .. l_counter
   LOOP
      SELECT fullname_pkg.fullname ( last_name, first_name )
        INTO l_name
        FROM employees
       WHERE employee_id = 137;
   END LOOP;

   show_elapsed ( 'Packaged function in select list' );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR i IN 1 .. l_counter
   LOOP
      SELECT MIN ( salary )
        INTO l_name
        FROM employees
       WHERE salary <= 25000;
   END LOOP;

   show_elapsed ( 'No function in where clause' );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR i IN 1 .. l_counter
   LOOP
      SELECT MIN ( salary )
        INTO l_name
        FROM employees
       WHERE salary <= max_salary ( job_id );
   END LOOP;

   show_elapsed ( 'Schema-level function in where clause' );
   --
   l_start_time := DBMS_UTILITY.get_cpu_time;

   FOR i IN 1 .. l_counter
   LOOP
      SELECT MIN ( salary )
        INTO l_name
        FROM employees
       WHERE salary <= fullname_pkg.max_salary ( job_id );
   END LOOP;

   show_elapsed ( 'Packaged function in where clause' );
/*
50000 iterations

Elapsed time for "No function in select list" = 1.87 seconds.
Elapsed time for "Schema-level function in select list" = 2.97 seconds.
Elapsed time for "Packaged function in select list" = 3.15 seconds.
Elapsed time for "No function in where clause" = 4.01 seconds.
Elapsed time for "Schema-level function in where clause" = 31.06 seconds.
Elapsed time for "Packaged function in where clause" = 33 seconds.

1000 iterations

*/
END;
/
