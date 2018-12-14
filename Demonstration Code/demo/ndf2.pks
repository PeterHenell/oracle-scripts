CREATE OR REPLACE PACKAGE ndf AUTHID CURRENT_USER
IS
   -- Load the cache
   PROCEDURE load_ndf_values;

   -- Return the "no data found" indicator
   FUNCTION ndf_value (
      table_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN ANYDATA;

   -- Was a "no data found" indicator returned?
   -- First, the generic version: pass in *any* kind of data...
   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   ANYDATA
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN;

   -- Now, overloadings for specific types...
   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN;

   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   NUMBER
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN;
END ndf;
/