DROP TABLE nasty_data;

DROP PROCEDURE backdoor;

REM This program is left wide-open to code injection through the
REM dynamic WHERE clause.

CREATE OR REPLACE PROCEDURE process_one_row (
   table_in   IN   VARCHAR2
 , where_in   IN   VARCHAR2
)
IS
   l_block   VARCHAR2 (32767)
      :=    'DECLARE l_row ' || table_in || '%ROWTYPE;'
         || 'BEGIN'
         || '   SELECT * INTO l_row '
         || 'FROM ' || table_in
         || ' WHERE ' || where_in || ';'
         || '   /*internal_process_data (l_row);*/ '
         || 'END;';
BEGIN
   EXECUTE IMMEDIATE l_block;
END process_one_row;
/

-- Intended usage

BEGIN
   process_one_row ('EMPLOYEES', 'employee_id=101');
END;
/

BEGIN
   process_one_row
      ('EMPLOYEES'
     , 'employee_id=101; 
	   EXECUTE IMMEDIATE ''CREATE TABLE nasty_data (mycol NUMBER)'''
      );
END;
/

BEGIN
   process_one_row
      ('EMPLOYEES'
     , 'employee_id=101; 
	   EXECUTE IMMEDIATE 
	      ''CREATE PROCEDURE backdoor (str VARCHAR2) 
		    AS BEGIN EXECUTE IMMEDIATE str; END;'''
      );
END;
/

REM One way to minimize the danger of injection is to avoid the
REM completely generic WHERE clause and instead code for
REM specific, anticipated variations.

CREATE OR REPLACE PROCEDURE process_one_row (
   table_in    IN   VARCHAR2
 , value1_in   IN   VARCHAR2
 , value2_in   IN   DATE
)
IS
   l_where   VARCHAR2 (32767);
BEGIN
   IF table_in = 'EMPLOYEES'
   THEN
      l_where := 'last_name = :name AND hire_date < :hdate';
   ELSIF table_in = 'DEPARTMENTS'
   THEN
      l_where := 'name LIKE :name AND incorporation_date = :hdate';
   ELSE
      raise_application_error (-20000
                             ,    'Invalid table name for process_one_row: '
                               || table_in
                              );
   END IF;

   EXECUTE IMMEDIATE    'DECLARE l_row '
                     || table_in
                     || '%ROWTYPE;'
                     || 'BEGIN '
                     || '   SELECT * INTO l_row '
                     || 'FROM '
                     || table_in
                     || ' WHERE ' || l_where || ';'
                     || 'END;'
               USING value1_in, value2_in;
END process_one_row;
/

/* But still could have a problem with the table name: */

CREATE OR REPLACE PROCEDURE process_one_row (
   table_in    IN   VARCHAR2
)
IS
   l_query   VARCHAR2 (32767);
BEGIN
   l_query :=
         'DECLARE l_row employees%ROWTYPE;'
      || 'BEGIN '
      || '   SELECT * INTO l_row '
      || 'FROM '
      || table_in
      || ' WHERE employee_id = 137;'
      || 'END;';

   EXECUTE IMMEDIATE l_query;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (l_query);
      RAISE;
END process_one_row;
/

BEGIN
   process_one_row (   'employees WHERE employee_id = 137;'
                    || ' delete from employees '
                   );
END;
/

/* Use DBMS_ASSERT to validate the table name! */

CREATE OR REPLACE PROCEDURE process_one_row (
   table_in    IN   VARCHAR2
)
IS
   l_query   VARCHAR2 (32767);
   l_table   VARCHAR2 (32767);
BEGIN
   l_table := SYS.dbms_assert.sql_object_name (table_in);
   l_query :=
         'DECLARE l_row employees%ROWTYPE;'
      || 'BEGIN '
      || '   SELECT * INTO l_row '
      || 'FROM '
      || l_table
      || ' WHERE employee_id = 137;'
      || 'END;';

   EXECUTE IMMEDIATE l_query;
EXCEPTION
   WHEN OTHERS
   THEN
      SYS.DBMS_OUTPUT.put_line (l_query);
      RAISE;
END process_one_row;
/

BEGIN
   process_one_row (   'employees WHERE employee_id = 137;'
                    || ' delete from employees '
                  , 'abc'
                  , SYSDATE
                   );
END;
/

