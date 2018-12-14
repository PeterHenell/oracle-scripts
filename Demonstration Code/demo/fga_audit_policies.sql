set lines 160 
column "name" format a15 
column "schema" format a10 
column "table" format a10 
column "column" format a10 
column "text" format a15 
column "e" format a3 
select policy_name    "name", 
       object_schema  "schema", 
       object_name    "table", 
       policy_column  "column", 
       policy_text    "text", 
       enabled        "e" 
  from sys.dba_audit_policies; 
