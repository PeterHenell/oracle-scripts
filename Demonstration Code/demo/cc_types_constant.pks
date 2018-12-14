CREATE OR REPLACE PACKAGE cc_types
/*
Codecheck: the QA utility for PL/SQL code
Copyright (C) 2002, Steven Feuerstein
All rights reserved

cc_types: API to datatype reference and rules
*/
--
/*
TO DO:
- NCHAR 286, NVARCHAR2 287, NCLOB 288: these datatypes are only
  distinguishable from ALL_ARGUMENTS.
*/
IS 
   c_varchar2         CONSTANT PLS_INTEGER := 1;
   c_varchar         CONSTANT PLS_INTEGER := 1;
   c_number           CONSTANT PLS_INTEGER := 2;
   c_integer          CONSTANT PLS_INTEGER := 2; -- Same as NUMBER...
   c_binary_integer   CONSTANT PLS_INTEGER := 3;
   c_pls_integer      CONSTANT PLS_INTEGER := 3;
   c_long             CONSTANT PLS_INTEGER := 8;
   c_rowid            CONSTANT PLS_INTEGER := 11;
   c_date             CONSTANT PLS_INTEGER := 12;
   c_raw              CONSTANT PLS_INTEGER := 23;
   c_longraw          CONSTANT PLS_INTEGER := 24;
   c_opaque           CONSTANT PLS_INTEGER := 58;
   c_char             CONSTANT PLS_INTEGER := 96;
   c_refcursor        CONSTANT PLS_INTEGER := 102;
   c_urowid           CONSTANT PLS_INTEGER := 104;
   c_mlslabel         CONSTANT PLS_INTEGER := 106;
   c_clob             CONSTANT PLS_INTEGER := 112;
   c_blob             CONSTANT PLS_INTEGER := 113;
   c_bfile            CONSTANT PLS_INTEGER := 114;
   c_cfile            CONSTANT PLS_INTEGER := 115;
   c_object_type      CONSTANT PLS_INTEGER := 121;
   c_nested_table     CONSTANT PLS_INTEGER := 122;
   c_varray           CONSTANT PLS_INTEGER := 123;
   c_timestamp        CONSTANT PLS_INTEGER := 180;
   c_timestamp_tz     CONSTANT PLS_INTEGER := 181;
   c_interval_ym      CONSTANT PLS_INTEGER := 182;
   c_interval_ds      CONSTANT PLS_INTEGER := 183;
   c_timestamp_ltz    CONSTANT PLS_INTEGER := 231;
   c_record           CONSTANT PLS_INTEGER := 250;
   c_indexby_table    CONSTANT PLS_INTEGER := 251;
   c_boolean          CONSTANT PLS_INTEGER := 252;
   --
   -- These last three are values from SQL. In PL/SQL, they have
   -- have the same type numbers as their single byte cousins.
   -- They are, in other words, indistinguishable as parameter types.
   c_nchar            CONSTANT PLS_INTEGER := 286;
   c_nvarchar2        CONSTANT PLS_INTEGER := 287;
   c_nclob            CONSTANT PLS_INTEGER := 288;

      -- Holds the names of the datatypes 
   c_datatype_names   constant DBMS_DESCRIBE.varchar2_table :=
      load_type_translators;
   function load_type_translators return DBMS_DESCRIBE.varchar2_table;
   
   FUNCTION NAME (code_in IN PLS_INTEGER)
      RETURN VARCHAR2;

   FUNCTION is_complex_type (type_in IN PLS_INTEGER)
      RETURN BOOLEAN;
   
   FUNCTION is_record_type (type_in IN PLS_INTEGER)
      RETURN BOOLEAN;  

   FUNCTION is_rowtype (type_in IN PLS_INTEGER, type_subname_in in varchar2)
      RETURN BOOLEAN;

   FUNCTION in_same_family (type1_in IN PLS_INTEGER, type2_in IN PLS_INTEGER)
      RETURN BOOLEAN;
	  
   FUNCTION is_a_trouble_type (code_in IN PLS_INTEGER)
      RETURN BOOLEAN;
  
   PROCEDURE show_datatypes_to_avoid (include_header_in IN BOOLEAN := TRUE );

END cc_types;
/
