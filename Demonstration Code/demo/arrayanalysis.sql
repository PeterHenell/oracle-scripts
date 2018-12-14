/*
|| Summary: Compare performance and memory utilization of varrays
||   and nested tables.
||
|| Author: Bill Pribyl
*/
SET ECHO OFF TIMING OFF VERIFY OFF
SPOOL &&path_to_log_file
COLUMN SEGMENT_NAME FORMAT A30
UNDEFINE number_of_records_to_insert
DEFINE segment_name_pattern='A_TABLE_OF%'
DROP TYPE an_array_t FORCE;
DROP TABLE chained_rows;
@$ORACLE_HOME/rdbms/admin/utlchain.sql
SET ECHO ON

CREATE OR REPLACE TYPE an_array_t AS VARRAY(8) OF NUMBER;
/

/* First we'll create a table of arrays, and a table of numbers... 
|| We'll do this as procedures so we can easily run them later with
|| different storage parameters.
*/

SET ECHO ON
CREATE OR REPLACE PROCEDURE bp_build_array_table (the_pctfree IN PLS_INTEGER,
   the_extent_size IN VARCHAR2)
AUTHID CURRENT_USER
AS
BEGIN
   BEGIN 
      EXECUTE IMMEDIATE 'DROP TABLE a_table_of_arrays';
   EXCEPTION WHEN OTHERS THEN NULL;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE a_table_of_arrays ( 
      the_key VARCHAR2(100), array1 an_array_t, 
      array2 an_array_t, array3 an_array_t) 
      STORAGE (INITIAL ' || the_extent_size || ' NEXT ' || the_extent_size 
      || ' PCTINCREASE 0 MAXEXTENTS UNLIMITED) PCTFREE ' || the_pctfree;
END;
/

BEGIN
   bp_build_array_table(0, '&&extent_size');
END;
/

CREATE OR REPLACE PROCEDURE bp_build_num_table (the_pctfree IN PLS_INTEGER,
   the_extent_size IN VARCHAR2)
AUTHID CURRENT_USER
AS
BEGIN
   BEGIN 
      EXECUTE IMMEDIATE 'DROP TABLE a_table_of_numbers';
   EXCEPTION WHEN OTHERS THEN NULL;
   END;
   EXECUTE IMMEDIATE 'CREATE TABLE a_table_of_numbers (
   the_key VARCHAR2(100),
   num1 NUMBER, num2 NUMBER, num3 NUMBER, num4 NUMBER, num5 NUMBER, num6 NUMBER,
   num7 NUMBER, num8 NUMBER, num9 NUMBER, num10 NUMBER, num11 NUMBER, num12 NUMBER,
   num13 NUMBER, num14 NUMBER, num15 NUMBER, num16 NUMBER, num17 NUMBER, num18 NUMBER,
   num19 NUMBER, num20 NUMBER, num21 NUMBER, num22 NUMBER, num23 NUMBER, num24 NUMBER)
STORAGE (INITIAL ' || the_extent_size || ' NEXT ' || the_extent_size || ' PCTINCREASE 0 MAXEXTENTS UNLIMITED)
PCTFREE ' || the_pctfree;
END;
/

BEGIN
   bp_build_num_table(0, '&&extent_size');
END;
/

/* Next we will attempt to populate the table of arrays with a bulk bind... */

DECLARE
   TYPE vctab_t IS TABLE OF VARCHAR2(100);
   TYPE numtab_t IS TABLE OF an_array_t;
   vctab vctab_t := vctab_t();
   numtab numtab_t := numtab_t();
BEGIN
   vctab.EXTEND(&&number_of_records_to_insert);
   numtab.EXTEND(&&number_of_records_to_insert);
   FOR i IN 1..&&number_of_records_to_insert
   LOOP
      vctab(i) := TO_CHAR(i);
      numtab(i) := an_array_t(1.1, null, 3.3, 4.4, null, null, null, 8.8);
   END LOOP;
   FORALL i IN 1..&&number_of_records_to_insert
      INSERT INTO a_table_of_arrays VALUES (vctab(i), numtab(i), numtab(i), numtab(i));
END;
/

/* Notice the error above -- you can't bulk bind a varray! So we have to use conventional bind... 
|| again as a procedure so we can run it easily later
*/

CREATE OR REPLACE PROCEDURE bp_populate_array_table (howmany IN PLS_INTEGER,
   array1_value IN an_array_t, array2_value IN an_array_t, array3_value IN an_array_t)
AS
BEGIN
   FOR i IN 1..howmany
   LOOP
      INSERT INTO a_table_of_arrays VALUES (TO_CHAR(i), array1_value, array2_value, array3_value);
   END LOOP;
END;
/


CREATE OR REPLACE PROCEDURE bp_populate_num_table (howmany IN PLS_INTEGER,
   n1val IN NUMBER, n2val IN NUMBER, n3val IN NUMBER, n4val IN NUMBER, n5val IN NUMBER,
   n6val IN NUMBER, n7val IN NUMBER, n8val IN NUMBER)
AS
   TYPE numtab_t IS TABLE OF NUMBER;
   TYPE chartab_t IS TABLE OF VARCHAR2(100);
   numtab1 numtab_t := numtab_t();
   numtab2 numtab_t := numtab_t();
   numtab3 numtab_t := numtab_t();
   numtab4 numtab_t := numtab_t();
   numtab5 numtab_t := numtab_t();
   numtab6 numtab_t := numtab_t();
   numtab7 numtab_t := numtab_t();
   numtab8 numtab_t := numtab_t();
   chartab chartab_t := chartab_t();
BEGIN
   numtab1.EXTEND(howmany);
   numtab2.EXTEND(howmany);
   numtab3.EXTEND(howmany);
   numtab4.EXTEND(howmany);
   numtab5.EXTEND(howmany);
   numtab6.EXTEND(howmany);
   numtab7.EXTEND(howmany);
   numtab8.EXTEND(howmany);
   chartab.EXTEND(howmany);

   FOR i IN 1..howmany
   LOOP
      chartab(i) := TO_CHAR(i);
      numtab1(i) := n1val;
      numtab2(i) := n2val;
      numtab3(i) := n3val;
      numtab4(i) := n4val;
      numtab5(i) := n5val;
      numtab6(i) := n6val;
      numtab7(i) := n7val;
      numtab8(i) := n8val;
   END LOOP;

   FORALL i IN 1..howmany
      INSERT INTO a_table_of_numbers VALUES (chartab(i),
         numtab1(i),numtab2(i),numtab3(i),numtab4(i),numtab5(i),numtab6(i),numtab7(i),numtab8(i),
         numtab1(i),numtab2(i),numtab3(i),numtab4(i),numtab5(i),numtab6(i),numtab7(i),numtab8(i),
         numtab1(i),numtab2(i),numtab3(i),numtab4(i),numtab5(i),numtab6(i),numtab7(i),numtab8(i));
END;
/

SET TIMING ON

DECLARE 
   an_array an_array_t := an_array_t(1.1, null, 3.3, 4.4, null, null, null, 8.8);
BEGIN
   bp_populate_array_table(&&number_of_records_to_insert, an_array, an_array, an_array);
END;
/

/* Above just inserted records with varrays--notice how long it takes.  Populate the normal table using a bulk bind... */

BEGIN
   bp_populate_num_table(&&number_of_records_to_insert, 1.1, null, 3.3, 4.4, null, null, null, 8.8);
END;
/

SET TIMING OFF

/* Which insert was faster, and by how much?  Now see how the storage compares... */

COMMIT;

SET ECHO OFF
@sizer

ANALYZE TABLE a_table_of_arrays LIST CHAINED ROWS;
ANALYZE TABLE a_table_of_numbers LIST CHAINED ROWS;
SET ECHO ON
/* Ensure there are no chained rows -- should get "no rows selected" */
SELECT table_name, COUNT(*) FROM chained_rows GROUP BY table_name;
TRUNCATE TABLE chained_rows;

/* Here is the little function we need to extract the ith element from a varray for sums... */

CREATE OR REPLACE FUNCTION ith_elt(the_array IN an_array_t, i IN PLS_INTEGER)
RETURN NUMBER
PARALLEL_ENABLE
AS
   BEGIN
      RETURN the_array(i);
   EXCEPTION WHEN COLLECTION_IS_NULL
   THEN
      RETURN NULL;
   END;
/

/* See how the performance of sums compares... */

SET TIMING ON
SELECT SUM(ith_elt(array1, 1)) FROM a_table_of_arrays;
SELECT SUM(num1) FROM a_table_of_numbers;
SET TIMING OFF

/* create a function to set the ith element (so we can do an update): */
CREATE OR REPLACE FUNCTION set_ith_elt(the_array IN an_array_t, i IN PLS_INTEGER, new_value IN NUMBER)
RETURN an_array_t
PARALLEL_ENABLE
AS
      dummy_array an_array_t := the_array;
   BEGIN
      DECLARE
      BEGIN
         dummy_array(i) := new_value;
         RETURN dummy_array;
      EXCEPTION WHEN COLLECTION_IS_NULL
         THEN
            dummy_array := an_array_t();
            dummy_array(i) := new_value;
            RETURN dummy_array;
      END;
   EXCEPTION
      WHEN SUBSCRIPT_BEYOND_COUNT
      THEN
         dummy_array.EXTEND(i - dummy_array.COUNT);
         dummy_array(i) := new_value;
         RETURN dummy_array;
   END;
/
 
/* Re-create the tables with some sort of PCTFREE so that row chaining doesn't
|| pollute our results
*/

DROP TABLE a_table_of_arrays;
DROP TABLE a_table_of_numbers;

BEGIN
   bp_build_array_table(20, '&&extent_size');
END;
/

BEGIN
   bp_build_num_table(20, '&&extent_size');
END;
/

DECLARE 
   an_array an_array_t := an_array_t(1.1, null, 3.3, 4.4, null, null, null, 8.8);
BEGIN
   bp_populate_array_table(&&number_of_records_to_insert, an_array, an_array, an_array);
END;
/

BEGIN
   bp_populate_num_table(&&number_of_records_to_insert, 1.1, null, 3.3, 4.4, null, null, null, 8.8);
END;
/

/* and see how the performance of the updates compares.  notice that this is actually
|| creating an element where none existed...
*/

SET TIMING ON
UPDATE a_table_of_arrays
   SET array1 = set_ith_elt(array1, 7, 7.7);

COMMIT;

UPDATE a_table_of_numbers
   SET num7 = 7.7;
SET TIMING OFF ECHO OFF

ANALYZE TABLE a_table_of_arrays LIST CHAINED ROWS;
ANALYZE TABLE a_table_of_numbers LIST CHAINED ROWS;
SET ECHO ON
/* Ensure there are no chained rows -- should get "no rows selected" */
SELECT table_name, COUNT(*) FROM chained_rows GROUP BY table_name;
TRUNCATE TABLE chained_rows;
TRUNCATE TABLE a_table_of_arrays;
TRUNCATE TABLE a_table_of_numbers;

/* Now populate with all null values except the last of each group of 8... */
SET TIMING ON

DECLARE 
   an_array an_array_t := an_array_t(null, null, null, null, null, null, null, 1);
BEGIN
   bp_populate_array_table(&&number_of_records_to_insert, an_array, an_array, an_array);
END;
/

BEGIN
   bp_populate_num_table(&&number_of_records_to_insert, null, null, null, null, null, null, null, 1);
END;
/

SET TIMING OFF

/* Bulk binds should have been lots faster.  Now see how the storage compares... */
SET ECHO OFF
@sizer
SET ECHO ON
/* and look at the relative performance of the sum and update operations... */

SET TIMING ON
SELECT SUM(ith_elt(array1, 1)) FROM a_table_of_arrays;
SELECT SUM(num1) FROM a_table_of_numbers;
UPDATE a_table_of_arrays
   SET array1 = set_ith_elt(array1, 7, 7.7);

COMMIT;

UPDATE a_table_of_numbers
   SET num7 = 7.7;
SET TIMING OFF ECHO OFF

/* Again, there should be no chained rows */
ANALYZE TABLE a_table_of_arrays LIST CHAINED ROWS;
ANALYZE TABLE a_table_of_numbers LIST CHAINED ROWS;
SELECT table_name, COUNT(*) FROM chained_rows GROUP BY table_name;
SPOOL OFF
