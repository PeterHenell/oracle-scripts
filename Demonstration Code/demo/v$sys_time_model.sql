/* Many thanks to Guy Harrison for showing me this! */

WITH plsql_times
       AS (SELECT SUM (CASE stat_name
                            WHEN 'DB time'
                            THEN value/1000000 END) AS db_time,
                  SUM(CASE stat_name
                           WHEN 'PL/SQL execution elapsed time'
                           THEN value / 1000000 END) AS plsql_time
             FROM v$sys_time_model
            WHERE stat_name IN ('DB time',
                             'PL/SQL execution elapsed time'))
SELECT ROUND (db_time, 2) db_time_secs,
       ROUND (plsql_time, 2) plsql_time_secs,
       ROUND (plsql_time * 100 / db_time, 2) pct_plsql_time
  FROM plsql_times
/