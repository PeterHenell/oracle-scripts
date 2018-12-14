REM
REM Display contents of Fine Grained Audit Trail view
REM

set linesize 100
set pagesize 60
ttitle 'Contents of FGA_AUDIT_TRAIL View'
column "scn" format 9999999
column "when" format a10
column "db_user" format a10
column "os_user" format a20
column "host" format a25
column "policy" format a15

SELECT   scn "scn", TO_CHAR (TIMESTAMP, 'DD-MON-YY HH:MI:SS') "when",
         db_user
               "db_user", os_user "os_user", userhost "host",
         policy_name
               "policy"
    FROM SYS.dba_fga_audit_trail
ORDER BY TIMESTAMP DESC;
