set pagesize 66
column index_name format a20
column tablespace_name format a20
column column_name format a20
column pos format 99
select i.index_name, i.tablespace_name, uniqueness u, column_name, column_position pos
  from all_indexes i, all_ind_columns c
  where i.index_name = c.index_name
    and i.table_name = upper ('&&firstparm'); 
