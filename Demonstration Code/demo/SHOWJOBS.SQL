col job_definition clear
col job format 9999

col job_definition format a30 word_wrap
col username format a15

ALTER SESSION SET NLS_DATE_FORMAT='YYYY:MM:DD:HH24:MI:SS';

SELECT
        jr.job       job_id
       ,username     username
       ,jr.this_date start_date
       ,what         job_definition
  FROM 
        dba_jobs_running   jr
       ,dba_jobs           j
       ,v$session          s
 WHERE
        s.sid  = jr.sid
   AND  jr.job = j.job
ORDER BY jr.this_date;
