REM *******************************************
REM * demonstrates using DBMS_JOB.USER_EXPORT
REM *******************************************
set array 1
var job number
var jobstring VARCHAR2(2000)
col jobstring format a50 word_wrap
col what format a25 word_wrap
col interval format a20

ALTER SESSION SET NLS_DATE_FORMAT='YYYY:MM:DD:HH24:MI:SS';

BEGIN
   /* submit no-op job to execute every 30 seconds */
   DBMS_JOB.SUBMIT(:job,'begin null;end;',SYSDATE,'SYSDATE+1/2880');

   /* commit to make sure the submit "takes" */
   COMMIT;
   /* sleep for two minutes to let job execute a few times */
   --DBMS_LOCK.SLEEP(120);
END;
/

SELECT job,what,next_date,interval
  FROM user_jobs
 WHERE job = :job;

BEGIN
   /* export the job */
   DBMS_JOB.USER_EXPORT(:job,:jobstring);
END;
/

print jobstring

