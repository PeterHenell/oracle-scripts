SET PAGESIZE 66
SET VERIFY OFF
SET FEEDBACK OFF
SELECT TO_CHAR (line) || text	Line_of_code
  FROM user_source
 WHERE name=UPPER('&1')
   AND TYPE=UPPER('&2')
   AND line BETWEEN &3 -5 AND &3 + 5
   /* AND line BETWEEN &&3 AND &&4 */
/
