REM Run from SYSDBA account
REM Allow another non-SYSDBA to work with fine-grained auditing objects

grant execute on dbms_fga to &1;
grant select on dba_audit_policies to &1;
grant select on dba_fga_audit_trail to &1;
