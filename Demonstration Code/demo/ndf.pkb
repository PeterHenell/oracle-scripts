CREATE OR REPLACE PACKAGE BODY ndf
IS
   -- Take advantage of Oracle9i Database Release 2 indexing by strings.
   TYPE values_rt IS RECORD (
      ndf_string_value    ndf_table.ndf_string_value%TYPE
     ,ndf_numeric_value   ndf_table.ndf_numeric_value%TYPE
   );

   TYPE cache_state_tt IS TABLE OF values_rt
      INDEX BY VARCHAR2 (32767);

   g_cache_value      cache_state_tt;
   --
   c_delim   CONSTANT CHAR (1)       DEFAULT '^';

   FUNCTION cache_row (
      table_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2
     ,owner_in    IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN owner_in || c_delim || table_in || c_delim || column_in;
   END cache_row;

   PROCEDURE load_ndf_values
   IS
      TYPE ndf_table_aat IS TABLE OF ndf_table%ROWTYPE
         INDEX BY PLS_INTEGER;

      l_ndf_table    ndf_table_aat;

      TYPE ndf_column_aat IS TABLE OF ndf_column%ROWTYPE
         INDEX BY PLS_INTEGER;

      l_ndf_column   ndf_column_aat;
      l_row          PLS_INTEGER;
   BEGIN
      -- Bulk copy to local collection of records.
      SELECT *
      BULK COLLECT INTO l_ndf_table
        FROM ndf_table;

      SELECT *
      BULK COLLECT INTO l_ndf_column
        FROM ndf_column;

      l_row := l_ndf_table.FIRST;

      WHILE (l_row IS NOT NULL)
      LOOP
         g_cache_value (cache_row (l_ndf_table (l_row).owner
                                  ,l_ndf_table (l_row).table_name
                                  ,NULL
                                  )
                       ).ndf_string_value :=
                                       l_ndf_table (l_row).ndf_string_value;
         g_cache_value (cache_row (l_ndf_table (l_row).owner
                                  ,l_ndf_table (l_row).table_name
                                  ,NULL
                                  )
                       ).ndf_numeric_value :=
                                      l_ndf_table (l_row).ndf_numeric_value;
         l_row := l_ndf_table.NEXT (l_row);
      END LOOP;

      --
      l_row := l_ndf_column.FIRST;

      WHILE (l_row IS NOT NULL)
      LOOP
         g_cache_value (cache_row (l_ndf_column (l_row).owner
                                  ,l_ndf_column (l_row).table_name
                                  ,l_ndf_column (l_row).column_name
                                  )
                       ).ndf_string_value :=
                                      l_ndf_column (l_row).ndf_string_value;
         g_cache_value (cache_row (l_ndf_column (l_row).owner
                                  ,l_ndf_column (l_row).table_name
                                  ,l_ndf_column (l_row).column_name
                                  )
                       ).ndf_numeric_value :=
                                     l_ndf_column (l_row).ndf_numeric_value;
         l_row := l_ndf_column.NEXT (l_row);
      END LOOP;
   END load_ndf_values;

   FUNCTION ndf_string_value (
      table_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN ndf_table.ndf_string_value%TYPE
   IS
   BEGIN
      RETURN g_cache_value (cache_row (NVL (UPPER (owner_in), USER)
                                      ,table_in
                                      ,column_in
                                      )
                           ).ndf_string_value;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END ndf_string_value;

   FUNCTION ndf_numeric_value (
      table_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN ndf_table.ndf_numeric_value%TYPE
   IS
   BEGIN
      RETURN g_cache_value (cache_row (NVL (UPPER (owner_in), USER)
                                      ,table_in
                                      ,column_in
                                      )
                           ).ndf_numeric_value;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END ndf_numeric_value;

   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   ndf_table.ndf_string_value%TYPE
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN
   IS
      l_ndf_string_value   ndf_table.ndf_string_value%TYPE;
   BEGIN
      l_ndf_string_value :=
                          ndf_string_value (table_in, column_in, owner_in);
      --
      RETURN    l_ndf_string_value = value_in
             OR (l_ndf_string_value IS NULL AND value_in IS NULL);
   END ndf_returned;

   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   ndf_table.ndf_numeric_value%TYPE
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN
   IS
      l_ndf_numeric_value   ndf_table.ndf_numeric_value%TYPE;
   BEGIN
      l_ndf_numeric_value :=
                         ndf_numeric_value (table_in, column_in, owner_in);
      --
      RETURN    l_ndf_numeric_value = value_in
             OR (l_ndf_numeric_value IS NULL AND value_in IS NULL);
   END ndf_returned;
BEGIN
   load_ndf_values;
END ndf;
/