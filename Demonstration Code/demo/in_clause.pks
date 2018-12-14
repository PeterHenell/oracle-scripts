CREATE OR REPLACE PACKAGE in_clause
/*
| Demonstrate various ways to implement a dynamic IN clause
|
|    Author: Steven Feuerstein, steven@stevenfeuerstein.com
|    Copyright 2005
|
| Run the in_clause_setup.sql script to set up the
| necessary database objects.
*/
IS
   -- Returns a cursor variable based on the Oracle9iR2-defined
   -- weak ref cursor type.
   FUNCTION nds_list ( list_in IN VARCHAR2 )
      RETURN sys_refcursor;

   FUNCTION nds_bulk_list ( list_in IN VARCHAR2 )
      RETURN in_clause_tab_nt;

   -- Use nds_bulk_list as a table function and return a cursor variable.
   FUNCTION nds_bulk_list2 ( list_in IN VARCHAR2 )
      RETURN sys_refcursor;

   FUNCTION dbms_sql_list ( list_in IN VARCHAR2 )
      RETURN in_clause_tab_nt;

   FUNCTION nested_table_list ( list_in IN pky_nt )
      RETURN sys_refcursor;

   FUNCTION nested_table_list2 ( list_in IN pky_nt )
      RETURN sys_refcursor;

   FUNCTION member_of_list ( list_in IN pky_nt )
      RETURN sys_refcursor;

   FUNCTION static_in_list ( list_in IN pky_nt )
      RETURN sys_refcursor;

   PROCEDURE gen_static_in_query (
      table_in          IN   VARCHAR2
    , array_in          IN   VARCHAR2
    , never_value_in    IN   VARCHAR2 := 'NULL'
    , num_elements_in   IN   PLS_INTEGER := 1000
    , to_file_in        IN   BOOLEAN := FALSE
    , file_in           IN   VARCHAR2 := NULL
    , dir_in            IN   VARCHAR2 := NULL
   );

   PROCEDURE test_varieties (
      iterations_in    IN   PLS_INTEGER DEFAULT 1
    , list_in          IN   VARCHAR2 DEFAULT '1,3'
    , show_timing_in   IN   BOOLEAN DEFAULT FALSE
    , show_data_in     IN   BOOLEAN DEFAULT FALSE
   );
END in_clause;
/