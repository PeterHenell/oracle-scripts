select sql_id from v$sql where sql_text like 'select * from profits%'
/
pau
alter session set events 'trace[rdbms.sql_optimizer.*][sql:0anpyjzyj8by6]'
/
pau
@q1
pau
alter session set events 'trace[rdbms.sql_optimizer.*] off'
/
@spid
pau