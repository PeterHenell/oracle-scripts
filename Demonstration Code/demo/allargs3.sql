set linesize 120
set pagesize 60
set verify off
column Argname format a20
column ovld format a5
column Type format a15
column type_owner format a15
column type_name format a15
column type_subname format a25
column pls_type format a15

ttitle 'PL/SQL Types for "&1..&2"'
SELECT DECODE (
          POSITION,
          0,
          '<RETURN Value>',
          DECODE (
             argument_name,
             NULL,
             LPAD (' ', 2 * data_level, ' ') || NVL (
                                                   argument_name,
                                                   '<Anonymous>'
                                                ),
             LPAD (' ', 2 * data_level, ' ') || argument_name
          )
       ) argname,
       data_type TYPE, type_owner, type_name, type_subname
  FROM all_arguments
 WHERE owner = USER
   AND package_name = UPPER ('&1')
   AND object_name = UPPER ('&2')
   AND type_name IS NOT NULL;
