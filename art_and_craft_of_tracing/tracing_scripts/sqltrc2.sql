set echo on
select sql_id, sql_text from v$sql where sql_text = 'select * from profits where cust_id = 5587'
/
pau
alter session set events 'sql_trace[SQL: 0anpyjzyj8by6]'
/
pau
@q1
pau
alter session set events 'sql_trace[SQL: 0anpyjzyj8by6] off'
/
@spid
