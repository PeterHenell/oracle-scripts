/* 
Raise and propagate an Oracle error, then
trap that error and extract information about the error.
*/

CREATE OR REPLACE PROCEDURE dept_sal (
   department_id_in IN PLS_INTEGER)
IS
   l_max_salary   NUMBER;
BEGIN
   l_max_salary := CASE
                     WHEN department_id_in > 100
                        THEN 10000
                     ELSE 20000
                  END;

   IF department_id_IN > 100
   THEN
      RAISE DUP_VAL_ON_INDEX;
   ELSE
      RAISE NO_DATA_FOUND;
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX
   THEN
      /* Trap the error, add some context, pass it along. */
      q$error_manager.raise_unanticipated (   /* Custom name-value pairs */
                                           name1_in       => 'DEPARTMENT ID'
                                         , value1_in      => department_id_in
                                         , name2_in       => 'MAX SALARY'
                                         , value2_in      => l_max_salary
                                         /* Substitution name-value pairs */
      ,                                    name3_in       => 'TABLE_NAME'
                                         , value3_in      => 'DEPARTMENTS'
                                         , name4_in       => 'OWNER'
                                         , value4_in      => USER
                                          );
   WHEN OTHERS
   THEN
      /* Trap the error, add some context, pass it along. */
      q$error_manager.raise_unanticipated (   /* Custom name-value pairs */
                                           name1_in       => 'DEPARTMENT ID'
                                         , value1_in      => department_id_in
                                         , name2_in       => 'MAX SALARY'
                                         , value2_in      => l_max_salary
                                          );
END dept_sal;
/

DECLARE
   l_error   q$error_manager.error_info_rt;
BEGIN
   dept_sal (200);
EXCEPTION
   WHEN OTHERS
   THEN
      q$error_manager.get_error_info (l_error);
      DBMS_OUTPUT.put_line ('');
      DBMS_OUTPUT.put_line ('Error in DEPT_SAL Procedure:');
      DBMS_OUTPUT.put_line ('Code = ' || l_error.code);
      DBMS_OUTPUT.put_line ('Name = ' || l_error.NAME);
      DBMS_OUTPUT.put_line ('Text = ' || l_error.text);
      DBMS_OUTPUT.put_line ('Error Stack = ' || l_error.error_stack);
END;
/

DECLARE
   l_error   q$error_manager.error_info_rt;
BEGIN
   dept_sal (50);
EXCEPTION
   WHEN OTHERS
   THEN
      q$error_manager.get_error_info (l_error);
      DBMS_OUTPUT.put_line ('');
      DBMS_OUTPUT.put_line ('Error in DEPT_SAL Procedure:');
      DBMS_OUTPUT.put_line ('Code = ' || l_error.code);
      DBMS_OUTPUT.put_line ('Name = ' || l_error.NAME);
      DBMS_OUTPUT.put_line ('Text = ' || l_error.text);
      DBMS_OUTPUT.put_line ('Error Stack = ' || l_error.error_stack);
END;
/