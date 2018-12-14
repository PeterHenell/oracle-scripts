CREATE OR REPLACE PACKAGE ndf AUTHID CURRENT_USER
IS
   -- Load the cache
   PROCEDURE load_ndf_values;

   -- Return the string "no data found" indicator
   FUNCTION ndf_string_value (
      table_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN ndf_table.ndf_string_value%TYPE;

   -- Return the numeric "no data found" indicator
   FUNCTION ndf_numeric_value (
      table_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN ndf_table.ndf_numeric_value%TYPE;

   -- Was a string "no data found" indicator returned?
   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   ndf_table.ndf_string_value%TYPE
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN;

   -- Was a string "no data found" indicator returned?
   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   ndf_table.ndf_numeric_value%TYPE
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN;
END ndf;
/