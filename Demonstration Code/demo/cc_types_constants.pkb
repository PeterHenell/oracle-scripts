CREATE OR REPLACE PACKAGE BODY cc_types
/*
Codecheck: the QA utility for PL/SQL code
Copyright (C) 2002, Steven Feuerstein
All rights reserved

cc_types: API to datatype reference and rules
*/
IS 
   TYPE avoid_them_t IS TABLE OF VARCHAR2 (100)
      INDEX BY /*BINARY_INTEGER; --*/varchar2(100);

   trouble_types      avoid_them_t;

   -- Build lists of datatypes in the same family
   TYPE flags_by_varchar2_t IS TABLE OF BOOLEAN
      INDEX BY /*BINARY_INTEGER; --*/varchar2(100);

   TYPE family_index_t IS TABLE OF flags_by_varchar2_t
      INDEX BY /*BINARY_INTEGER; --*/varchar2(100); 

   same_family        family_index_t;

   -- Holds the codes for datatypes that are non-scalar types
   TYPE booleans_t IS TABLE OF BOOLEAN
      INDEX BY BINARY_INTEGER;

   c_complex_types    booleans_t;

   FUNCTION NAME (code_in IN PLS_INTEGER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN c_datatype_names (code_in);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;

   FUNCTION is_complex_type (type_in IN PLS_INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN c_complex_types.EXISTS (type_in);
   END;
   
   FUNCTION is_record_type (type_in IN PLS_INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN type_in = c_record;
   END;   

   FUNCTION is_rowtype (type_in IN PLS_INTEGER, type_subname_in in varchar2)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN type_in = c_record and type_subname_in is null;
   END; 

   PROCEDURE show_datatypes_to_avoid (include_header_in IN BOOLEAN := TRUE )
   IS 
      indx   VARCHAR2 (30) := trouble_types.FIRST;
   BEGIN
      IF include_header_in
      THEN
         cc_util.pl ('');
         cc_util.pl ('Datatypes to Avoid and Why:');
      END IF;

      cc_util.pl ('');

      LOOP
         EXIT WHEN indx IS NULL;
         cc_util.pl (trouble_types (indx));
         indx := trouble_types.NEXT (indx);
      END LOOP;

      cc_util.pl ('');
      cc_util.pl (
         'Note: Limitations in DBMS_DESCRIBE and USER_ARGUMENTS result'
      );
      cc_util.pl (
         '      in an inability to distinguish between certain datatypes,'
      );
      cc_util.pl (
         '      such as VARCHAR2 and CHAR. So review the list carefully.'
      );
      cc_util.pl ('');
   END;

   FUNCTION is_a_trouble_type (code_in IN PLS_INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN trouble_types.EXISTS (code_in);
   END;

   FUNCTION in_same_family (type1_in IN PLS_INTEGER, type2_in IN PLS_INTEGER)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN same_family (type1_in) (type2_in);
   EXCEPTION
     WHEN NO_DATA_FOUND THEN RETURN FALSE;
   END;
	  
   PROCEDURE load_in_same_family
   IS 
      PROCEDURE loadone (val1_in IN VARCHAR2, val2_in IN VARCHAR2)
      IS
      BEGIN
         same_family (val1_in) (val2_in) := TRUE ;
         same_family (val2_in) (val1_in) := TRUE ;
      END;
   BEGIN
      -- Define families of similar datatypes 
      loadone ('VARCHAR2', 'VARCHAR2');
      loadone ('VARCHAR2', 'VARCHAR');
      loadone ('VARCHAR2', 'CHAR');
      loadone ('VARCHAR2', 'NCHAR');
      loadone ('VARCHAR2', 'LONG');
      --
      loadone ('DATE', 'DATE');
      loadone ('DATE', 'TIMESTAMP');
      --
      loadone ('TIMESTAMP', 'TIMESTAMP');
      loadone ('TIMESTAMP', 'TIMESTAMP_TZ');
      loadone ('TIMESTAMP', 'TIMESTAMP_LTZ');
      --
      loadone ('NUMBER', 'NUMBER');
      loadone ('NUMBER', 'INTEGER');
      loadone ('NUMBER', 'BINARY_INTEGER');
      loadone ('NUMBER', 'PLS_INTEGER');
      loadone ('NUMBER', 'NATURAL');
      loadone ('NUMBER', 'POSITIVE');
      loadone ('NUMBER', 'FLOAT');
   END;

   PROCEDURE load_trouble_types
   IS
   BEGIN
      -- Datatypes to be avoided 
      trouble_types (c_varchar) :=
                           'Using VARCHAR or NVARCHAR? Use VARCHAR2 instead.';
      trouble_types (c_char) :=
                    'Using CHAR or NCHAR? Use VARCHAR2 or NVARCHAR2 instead.';
      trouble_types (c_long) := 'Using LONG? Use CLOB instead.';
      trouble_types (c_longraw) := 'Using LONGRAW? Use BLOB instead.';
      trouble_types (c_binary_integer) :=
                             'Using BINARY_INTEGER? Use PLS_INTEGER instead.';      
      trouble_types (c_binary_integer) := 'Use PLS_INTEGER instead';
   END;

   function load_type_translators return DBMS_DESCRIBE.varchar2_table
   IS
   l_col DBMS_DESCRIBE.varchar2_table;
   BEGIN
      -- Allow for easy translation between ALL_ARGUMENTS
	  -- and DBMS_DESCRIBE representations.
      l_col (c_varchar2) := 'VARCHAR2';
      l_col (c_number) := 'NUMBER';
      l_col (c_binary_integer) := 'BINARY_INTEGER';
      l_col (c_long) := 'LONG';
      l_col (c_rowid) := 'ROWID';
      l_col (c_date) := 'DATE';
      l_col (c_raw) := 'RAW';
      l_col (c_longraw) := 'LONG RAW';
      l_col (c_char) := 'CHAR';
      l_col (c_mlslabel) := 'MLSLABEL';
      l_col (c_record) := 'RECORD';
      l_col (c_indexby_table) := 'INDEX-BY TABLE';
      l_col (c_boolean) := 'BOOLEAN';
      l_col (c_object_type) := 'OBJECT TYPE';
      l_col (c_nested_table) := 'NESTED TABLE';
      l_col (c_varray) := 'VARRAY';
      l_col (c_clob) := 'CLOB';
      l_col (c_blob) := 'BLOB';
      l_col (c_bfile) := 'BFILE';
	  RETURN l_col;
   END;

   PROCEDURE load_complex_types
   IS
   BEGIN
      c_complex_types (c_record) := TRUE ;
      c_complex_types (c_indexby_table) := TRUE ;
      c_complex_types (c_object_type) := TRUE ;
      c_complex_types (c_nested_table) := TRUE ;
      c_complex_types (c_varray) := TRUE ;
   END;

BEGIN
   load_in_same_family;
   load_trouble_types;
   --load_type_translators;
   load_complex_types;
END cc_types;


/
