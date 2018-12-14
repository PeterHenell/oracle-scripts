COLUMN calc_date FORMAT A17
BREAK ON tablespace_name SKIP 1
SET PAGESIZE 100

SELECT tablespace_name,    
       TO_CHAR (calc_date, 'MM/DD/YY HH24:MI:SS') calc_date,
       total_bytes,
       free_bytes
  FROM db_space
 WHERE tablespace_name != '*JOB NUMBER*'
   AND calc_date >= &&firstparm
 ORDER BY tablespace_name, calc_date;