/*
Created by Guy Harrison.
 
How much time is PL/SQL execution contributing to our 
overall database execution time?

This query reports time spent executing PL/SQL statements only:  
time spent on SQL statements included within PL/SQL programs 
is not reported. 
*/
WITH plsql_times
       AS (SELECT SUM (CASE stat_name WHEN 'DB time' THEN VALUE / 1000000 END
                      )
                     AS db_time
                , SUM(CASE stat_name
                         WHEN 'PL/SQL execution elapsed time'
                         THEN
                            VALUE / 1000000
                      END)
                     AS plsql_time
             FROM v$sys_time_model
            WHERE stat_name IN ('DB time', 'PL/SQL execution elapsed time'))
SELECT ROUND (db_time, 2) db_time_secs
     , ROUND (plsql_time, 2) plsql_time_secs
     , ROUND (plsql_time * 100 / db_time, 2) pct_plsql_time
  FROM plsql_times
/

/*
For individual SQL and PL/SQL blocks, we can get a breakdown 
of PL/SQL and SQL time with a query against V$SQL, in which 
the PLSQL_EXEC_TIME column reveals how much time was spent 
executing PL/SQL code within the SQL statements.  
The following query lists SQL statements that include PL/SQL 
execution time, and shows how much of the total SQL execution 
time was PL/SQL, and how much that statement contributed to the 
database's total PL/SQL overhead.
*/
SELECT sql_id,
       SUBSTR (sql_text, 1, 150) AS sql_text,
       ROUND (elapsed_time / 1000) AS elapsed_ms,
       ROUND (plsql_exec_time / 1000) plsql_ms,
       ROUND (plsql_exec_time * 100 / elapsed_time, 2) pct_plsql,
       ROUND (plsql_exec_time * 100 / SUM (plsql_exec_time) OVER (), 2)
          pct_total_plsql
  FROM v$sql
 WHERE plsql_exec_time > 0 AND elapsed_time > 0
ORDER BY plsql_exec_time DESC
/

