CREATE OR REPLACE PROCEDURE showany (any_in IN SYS.ANYDATA)
-- VERY MUCH UNDER CONSTRUCTION!
IS
   TYPE any_rt IS RECORD (
      v_date            DATE
    , v_number          NUMBER
    , v_raw             RAW
    , v_char            CHAR (2000)
    , v_varchar2        VARCHAR2 (32767)
    , v_varchar         VARCHAR2 (32767)
    , v_mlslabel        MLSLABEL
    , v_blob            BLOB
    , v_bfile           BFILE
    , v_clob            CLOB
    , v_cfile           cfile
    , v_timestamp       TIMESTAMP
    , v_timestamp_tz    TIMESTAMP WITH TIME ZONE
    , v_timestamp_ltz   TIMESTAMP WITH LOCAL TIME ZONE
    , v_interval_ym     INTERVAL YEAR TO MONTH
    , v_interval_ds     INTERVAL DAY TO SECOND
   );

   v_values                      any_rt;
   n                             NUMBER;
   v_type                        SYS.ANYTYPE;
   v_typecode                    PLS_INTEGER;
   v_typename                    VARCHAR2 (60);
   v_dummy                       PLS_INTEGER;
   non_null_anytype_for_number   EXCEPTION;
   unknown_typename              EXCEPTION;
BEGIN
   v_typecode := any_in.gettype (v_type /* OUT */);

   CASE v_typecode
      -- Date-related functionality
   WHEN typecode_date
      THEN
         v_dummy := generic_rec.DATA.getdate (v_values.v_date);
      WHEN typecode_timestamp
      THEN
         v_dummy := generic_rec.DATA.getdate (v_values.v_timestamp);
      WHEN typecode_timestamp_tz
      THEN
         v_dummy := generic_rec.DATA.getdate (v_values.v_timestamp_tz);
      WHEN typecode_timestamp_ltz
      THEN
         v_dummy := generic_rec.DATA.getdate (v_values.v_timestamp_ltz);
      WHEN typecode_interval_ym
      THEN
         v_dummy := generic_rec.DATA.getnumber (v_values.v_number);
      WHEN typecode_interval_ds
      THEN
         v_dummy := generic_rec.DATA.getnumber (v_values.v_number);
      WHEN typecode_number
      THEN
         v_dummy := generic_rec.DATA.getnumber (v_values.v_number);
      WHEN typecode_raw
      THEN
         v_dummy := generic_rec.DATA.getraw (v_values.v_raw);
      -- String-related functionality
   WHEN typecode_char
      THEN
         v_dummy := generic_rec.DATA.getchar (v_values.v_char);
      WHEN typecode_varchar2
      THEN
         v_dummy := generic_rec.DATA.getvarchar2 (v_values.v_varchar2);
      WHEN typecode_varchar
      THEN
         v_dummy := generic_rec.DATA.getvarchar (v_values.v_varchar);
      -- LOB-related datatypes
   WHEN typecode_blob
      THEN
         v_dummy := generic_rec.DATA.getblob (v_values.v_blob);
      WHEN typecode_bfile
      THEN
         v_dummy := generic_rec.DATA.getbfile (v_values.v_bfile);
      WHEN typecode_clob
      THEN
         v_dummy := generic_rec.DATA.getclob (v_values.v_clob);
      WHEN typecode_cfile
      THEN
         v_dummy := generic_rec.DATA.getcfile (v_values.v_cfile);
      WHEN typecode_object
      THEN
         -- Obtain information about each attribute of the object type.
         v_typename := generic_rec.DATA.gettypename ();
         v_dummy := generic_rec.DATA.getobject (v_pet /* OUT */);
      -- Composites and collections
   WHEN typecode_ref
      THEN
         NULL;
      WHEN typecode_varray
      THEN
         NULL;
      WHEN typecode_table
      THEN
         NULL;
      WHEN typecode_namedcollection
      THEN
         NULL;
      WHEN typecode_opaque
      THEN
         NULL;
      WHEN typecode_mlslabel
      THEN
         NULL;
   END CASE;
EXCEPTION
   WHEN non_null_anytype_for_number
   THEN
      raise_application_error
                     (-20000
                    ,    'Paradox: the return AnyType instance from GetType '
                      || 'should be NULL for all but user-defined types'
                     );
   WHEN unknown_typename
   THEN
      raise_application_error (-20000
                             ,    'Unknown user-defined type '
                               || v_typename
                               || ' - program written to handle only EMPLOYEE_T'
                              );
   WHEN DBMS_TYPES.type_mismatch
   THEN
      DBMS_OUTPUT.put_line ('This operation is not allowed on this type.');
END;
/