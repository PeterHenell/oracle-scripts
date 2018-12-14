select * from V$SESSION                     where username = 'PETEHENE';
select * from V$SESSTAT    where sid = 2017;

select disk_reads, buffer_gets, cpu_time, elapsed_time, fetches, physical_read_bytes, rows_processed, application_wait_time
from V$SQLSTATS  
where sql_id = 'dpqfqmsraru18' ;

select * from V$SESSION_WAIT                where sid = 2017;

select * from DBA_HIST_ACTIVE_SESS_HISTORY
where session_id = 2017 and session_serial# = 61491


-- get sql_id of your query
SELECT
        DBID
      , SQL_ID
      , SQL_TEXT
    FROM
        dba_hist_sqltext
    WHERE
        sql_text LIKE ‘%your query%’;

--DBA_HIST_SQLSTAT (Snaphost of SQL runtime statistics)
SELECT
        -- Snapshot Id
        SNAP_ID
        -- Sql Id
      , SQL_ID
      , SUM( CPU_TIME_DELTA ) CPU_TIME
      , SUM( ELAPSED_TIME_DELTA ) ELAPSED_TIME
      , SUM( EXECUTIONS_DELTA ) EXECUTIONS_DELTA
    FROM
        SYS.dba_hist_sqlstat
    where sql_id = 'dpqfqmsraru18'
    GROUP BY
        SNAP_ID
      , SQL_ID;