COLUMN recomp_date FORMAT A17
COLUMN description FORMAT A80
BREAK ON recomp_date SKIP 1
SET PAGESIZE 100
SET LINESIZE 120

SELECT TO_CHAR (recompiled_on, 'MM/DD/YY HH AM') recomp_date,
       description
  FROM recompile_log
 WHERE recompiled_on >= &&firstparm
 ORDER BY recompiled_on;
