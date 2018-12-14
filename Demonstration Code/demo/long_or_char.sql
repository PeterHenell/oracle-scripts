COLUMN overload heading OVLD format a4
COLUMN object_name format a15
COLUMN argument_name format a15
COLUMN data_type format a25
COLUMN position heading POS format 999
COLUMN sequence heading SEQ format 999
COLUMN data_level heading LVL format 999
BREAK ON object_name SKIP 1
SET PAGESIZE 66
SELECT object_name, argument_name, overload
     , POSITION, SEQUENCE, data_level, data_type
  FROM user_arguments
 WHERE data_type IN ('LONG','CHAR')
/