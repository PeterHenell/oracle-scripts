CREATE OR REPLACE PACKAGE BODY ndf
IS
   -- Take advantage of Oracle9i Database Release 2 indexing by strings.
   TYPE cache_state_tt IS TABLE OF ANYDATA
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
                       ) := l_ndf_table (l_row).ndf_value;
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
                       ) := l_ndf_column (l_row).ndf_value;
         l_row := l_ndf_column.NEXT (l_row);
      END LOOP;
   END load_ndf_values;

   FUNCTION ndf_value (
      table_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN ANYDATA
   IS
   BEGIN
      RETURN g_cache_value (cache_row (NVL (UPPER (owner_in), USER)
                                      ,table_in
                                      ,column_in
                                      )
                           );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END ndf_value;

   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   ANYDATA
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN
   IS
      l_cache_value   ndf_table.ndf_value%TYPE;
      l_the_type      ANYTYPE;
      l_return        BOOLEAN;
   BEGIN
      l_cache_value := ndf_value (table_in, column_in, owner_in);

      -- Compare values of scalar types.
      CASE value_in.gettype (l_the_type)
         WHEN DBMS_TYPES.typecode_number
         THEN
            l_return := value_in.accessnumber = l_cache_value.accessnumber;
         WHEN DBMS_TYPES.typecode_varchar2
         THEN
            l_return :=
                    value_in.accessvarchar2 = l_cache_value.accessvarchar2;
         WHEN DBMS_TYPES.typecode_varchar
         THEN
            l_return :=
                      value_in.accessvarchar = l_cache_value.accessvarchar;
         WHEN DBMS_TYPES.typecode_char
         THEN
            l_return := value_in.accesschar = l_cache_value.accesschar;
         WHEN DBMS_TYPES.typecode_date
         THEN
            l_return := value_in.accessdate = l_cache_value.accessdate;
         WHEN DBMS_TYPES.typecode_timestamp
         THEN
            l_return :=
                       value_in.accessdate = l_cache_value.accesstimestamp;
         WHEN DBMS_TYPES.typecode_timestamp_ltz
         THEN
            l_return :=
               value_in.accesstimestampltz =
                                          l_cache_value.accesstimestampltz;
         WHEN DBMS_TYPES.typecode_timestamp_tz
         THEN
            l_return :=
               value_in.accesstimestamptz =
                                           l_cache_value.accesstimestamptz;
         WHEN DBMS_TYPES.typecode_interval_ym
         THEN
            l_return :=
                value_in.accessintervalym = l_cache_value.accessintervalym;
         WHEN DBMS_TYPES.typecode_interval_ds
         THEN
            l_return :=
                value_in.accessintervalds = l_cache_value.accessintervalds;
         WHEN DBMS_TYPES.typecode_clob
         THEN
            l_return := value_in.accessclob = l_cache_value.accessclob;
         ELSE
            l_return := NULL;
      END CASE;

      RETURN l_return;
   END ndf_returned;

   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   VARCHAR2
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN ndf_returned (table_in
                          ,ANYDATA.convertvarchar2 (value_in)
                          ,column_in
                          ,owner_in
                          );
   END ndf_returned;

   FUNCTION ndf_returned (
      table_in    IN   VARCHAR2
     ,value_in    IN   NUMBER
     ,column_in   IN   VARCHAR2 := NULL
     ,owner_in    IN   VARCHAR2 := NULL
   )
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN ndf_returned (table_in
                          ,ANYDATA.convertnumber (value_in)
                          ,column_in
                          ,owner_in
                          );
   END ndf_returned;
BEGIN
   load_ndf_values;
END ndf;
/