DROP TABLE plch_names
/

CREATE OR REPLACE PROCEDURE plch_show_count
IS
   l_count   PLS_INTEGER;
BEGIN
   EXECUTE IMMEDIATE 'SELECT COUNT (*) FROM plch_names' INTO l_count;

   DBMS_OUTPUT.put_line (l_count);
END;
/

CREATE OR REPLACE PROCEDURE plch_create_table (
   names_in IN DBMS_SQL.varchar2_table)
IS
   l_index   PLS_INTEGER;
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE plch_names (name VARCHAR2 (100))';

   l_index := names_in.FIRST;

   WHILE (l_index IS NOT NULL)
   LOOP
      INSERT INTO plch_names
           VALUES (names_in (l_index));

      l_index := names_in.NEXT (l_index);
   END LOOP;

   plch_show_count;
END;
/

DECLARE
   l_names   DBMS_SQL.varchar2_table;
BEGIN
   l_names (1) := 'Steven';
   l_names (100) := 'Eli';
   plch_create_table (l_names);
END;
/

DROP TABLE plch_names
/

/* Use nested table and TABLE operator:

   ORA-01027: bind variables not allowed for data definition operations
*/

CREATE OR REPLACE TYPE names_t IS TABLE OF VARCHAR2 (100)
/

CREATE OR REPLACE PROCEDURE plch_create_table (names_in IN names_t)
IS
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE plch_names 
      AS   
      SELECT COLUMN_VALUE name 
        FROM TABLE (CAST (:names AS names_t))'
      USING names_in;

   plch_show_count;
END;
/

DECLARE
   l_names   names_t := names_t ('1', '2');
BEGIN
   plch_create_table (l_names);
END;
/

DROP TABLE plch_names
/

/* Create table first, then populate with array. */

CREATE OR REPLACE TYPE names_t IS TABLE OF VARCHAR2 (100)
/

CREATE OR REPLACE PROCEDURE plch_create_table (names_in IN names_t)
IS
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE plch_names (name VARCHAR2(100))';

   EXECUTE IMMEDIATE 'INSERT INTO plch_names  
      SELECT COLUMN_VALUE FROM TABLE (:names)'
      USING names_in;

   plch_show_count;
END;
/

DECLARE
   l_names   names_t := names_t ('1', '2');
BEGIN
   plch_create_table (l_names);
END;
/

/* Use nested table and TABLE operator without CAST:

   ORA-22905: cannot access rows from a non-nested table item
   
   But if I add CAST, then it recognizes the bind variable
   as a nested table - and rejects binding in a DDL statement!
*/

DROP TABLE plch_names
/

CREATE OR REPLACE TYPE names_t IS TABLE OF VARCHAR2 (100)
/

CREATE OR REPLACE PROCEDURE plch_create_table (names_in IN names_t)
IS
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE plch_names 
      AS   
      SELECT COLUMN_VALUE name FROM TABLE (:names)'
      USING names_in;

   plch_show_count;
END;
/

DECLARE
   l_names   names_t := names_t ('1', '2');
BEGIN
   plch_create_table (l_names);
END;
/

/* Try to perform DML with an associative array - NO GO! 

   PLS-00457: expressions have to be of SQL types
*/

DROP TABLE plch_names
/

CREATE OR REPLACE PROCEDURE plch_create_table (
   names_in IN DBMS_SQL.varchar2_table)
IS
BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE plch_names (name VARCHAR2(100))';

   EXECUTE IMMEDIATE 'INSERT INTO plch_names  
      SELECT COLUMN_VALUE FROM TABLE (:names)'
      USING names_in;

   plch_show_count;
END;
/


DECLARE
   l_names   DBMS_SQL.varchar2_table;
BEGIN
   l_names (1) := 'Steven';
   l_names (100) := 'Eli';
   plch_create_table (l_names);
END;
/



