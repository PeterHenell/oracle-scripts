set linesize 90
set pagesize 60
set verify off
column Argname format a25
column ovld format a5
column pos format 9999
column seq format 9999
column lvl format 9999
column Type format a15
column defval format a6
column IN_OUT format 9999

ttitle 'Core ALL_ARGUMENTS Info for "&1..&2"'

SELECT overload ovld,
       DECODE (
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
       POSITION pos, SEQUENCE seq, data_level lvl, data_type TYPE,
       DEFAULT_VALUE
             defval, in_out
  FROM all_arguments
 WHERE owner = USER
   AND package_name = UPPER ('&1')
   AND object_name = UPPER ('&2');
