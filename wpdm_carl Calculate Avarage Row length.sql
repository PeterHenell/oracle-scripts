/********************************************************************
 * File:        carl.sql
 * Type:        SQL*Plus script
 * Author:      Tim Gorman (Evergreen Database Technologies, Inc.)
 * Date:        14-Jul-2012
 *
 * Description:
 *      DDL to create procedure named CARL (i.e. Calculate Average
 *      Row Length).  This script samples some or all of the rows in
 *      a table, as specified using the parameter IN_ROWS, and calculates
 *      the average row length.  Then, using gathered statistics information
 *      from the DBA_TAB_COLUMNS view, it determines what the average row
 *      length would be if all of the most-NULL columns are moved to the
 *      end of the row, thus taking advantage of Oracle's manner of not
 *      storing trailing null columns.
 *
 *      Details for verification can be obtained by having the procedure
 *      display all results by setting the parameter IN_DEBUG_FLAG > 0.
 *
 * Modification:
 ********************************************************************/
set echo on feedback on timing on
spool carl

select name from v$database;
show user

create or replace procedure carl(	in_owner in VARCHAR2,
					in_table in VARCHAR2,
					in_partn in VARCHAR2 default NULL,
					in_rows in INTEGER default NULL,
					in_debug_flag in INTEGER default 0)
is
	--
	type t_column_name		is table of varchar2(30) index by binary_integer;
	v_curr_clist			t_column_name;
	v_null_reorder_clist		t_column_name;
	type t_column_values		is table of number(6) index by binary_integer;
	v_colvals			t_column_values;
	v_null_reorder_n		t_column_values;
	v_sql_lines			dbms_sql.varchar2s;
	ub				integer;
	c				integer;
	n				integer;
	v_curr_row_len			integer;
	v_col_len			integer;
	v_null_reorder_row_len		integer;
	v_tot_curr_row_len		integer := 0;
	v_tot_null_reorder_row_len	integer := 0;
	v_row_cnt			integer := 0;
	v_trailing_nullcol_len		integer;
	--
	v_errctx			varchar2(2000);
	v_errmsg			varchar2(2000);
	--
begin
	--
	v_errctx := 'retrieve null-reorder column-list';
	select			column_name,
				column_id
	bulk collect into	v_null_reorder_clist,
				v_null_reorder_n
	from			dba_tab_columns
	where			owner = upper(in_owner)
	and			table_name = upper(in_table)
	order by		num_nulls asc,
				column_id asc;
	--
	v_errctx := 'retrieve current column-list';
	select			column_name,
				decode(column_id,1,'select 3+',',')||
					decode(data_type,
						'CLOB', 'dbms_lob.getlength('||column_name||')',
						'BLOB', 'dbms_lob.getlength('||column_name||')',
							'vsize('||column_name||')') expr
	bulk collect into	v_curr_clist,
				v_sql_lines
	from			dba_tab_columns
	where			owner = upper(in_owner)
	and			table_name = upper(in_table)
	order by		column_id asc;
	--
	v_errctx := 'finish constructing query';
	ub := v_sql_lines.last + 1;
	--
	if in_partn is not null then
		v_sql_lines(ub) := ' from '||upper(in_owner)||'.'||upper(in_table)||' partition ('||upper(in_partn)||')';
	else
		v_sql_lines(ub) := ' from '||upper(in_owner)||'.'||upper(in_table);
	end if;
	--
	if in_rows is not null then
		--
		ub := ub+1;
		v_sql_lines(ub) := 'where rownum <= '||to_char(in_rows);
		--
	end if;
	--
	if in_debug_flag > 0 then
		--
		dbms_output.put_line('SQL statement to be executed');
		dbms_output.put_line('============================');
		for n in v_sql_lines.first..v_sql_lines.last loop
			dbms_output.put_line('"'||v_sql_lines(n)||'"');
		end loop;
		dbms_output.put_line('============================');
		--
	end if;
	--
	v_errctx := 'dbms_sql.open_cursor';
	c := dbms_sql.open_cursor;
	--
	v_errctx := 'dbms_sql.parse';
	dbms_sql.parse(c, v_sql_lines, v_sql_lines.first, ub, TRUE, dbms_sql.native);
	--
	for n in v_curr_clist.first..v_curr_clist.last loop
		--
		v_errctx := 'dbms_sql.define_column(c,'||n||',v_colvals('||n||')';
		v_colvals(n) := null;
		dbms_sql.define_column(c,n,v_colvals(n));
		--
	end loop;
	--
	v_errctx := 'dbms_sql.execute';
	n := dbms_sql.execute(c);
	--
	loop
		--
		v_errctx := 'dbms_sql.fetch_rows';
		n := dbms_sql.fetch_rows(c);
		exit when n <> 1;
		--
		v_row_cnt := v_row_cnt + 1;
		--
		if in_debug_flag > 1 then
			dbms_output.put_line('#'||v_row_cnt||'...');
		end if;
		--
		v_curr_row_len := 0;
		v_trailing_nullcol_len := 0;
		--
		if in_debug_flag > 1 then
			dbms_output.put_line('..Current column order (in reverse):');
		end if;
		--
		for n in reverse v_curr_clist.first..v_curr_clist.last loop
			--
			v_errctx := 'dbms_sql.column_value(c,'||n||',v_colvals('||n||')';
			dbms_sql.column_value(c, n, v_colvals(n));
			--
			if v_colvals(n) is null then
				--
				if v_trailing_nullcol_len = 0 then
					v_col_len := 0;
				else
					v_col_len := 1;
				end if;
				--
			else /* v_colvals(n) is not null */
				--
				if v_colvals(n) < 254 then
					v_col_len := v_colvals(n) + 1;
				else
					v_col_len := v_colvals(n) + 3;
				end if;
				--
				v_trailing_nullcol_len := 1;
				--
			end if;
			--
			v_curr_row_len := v_curr_row_len + v_col_len;
			--
			if in_debug_flag > 1 then
				--
				dbms_output.put_line('...'||rpad(v_curr_clist(n),30,' ')||
					' = '||trim(to_char(v_col_len,'99,990'))||
					case when v_colvals(n) is null then '(NULL)' else '' end);
				--
			end if;
			--
		end loop;
		--
		v_tot_curr_row_len := v_tot_curr_row_len + v_curr_row_len;
		--
		if in_debug_flag > 1 then
			dbms_output.put_line('..After null reorder (also in reverse):');
		end if;
		--
		v_null_reorder_row_len := 0;
		v_trailing_nullcol_len := 0;
		for n in reverse v_null_reorder_clist.first..v_null_reorder_clist.last loop
			--
			if v_colvals(v_null_reorder_n(n)) is null then
				--
				if v_trailing_nullcol_len = 0 then
					v_col_len := 0;
				else
					v_col_len := 1;
				end if;
				--
			else /* v_colvals(v_null_reorder_n(n)) is not null */
				--
				if v_colvals(v_null_reorder_n(n)) < 254 then
					v_col_len := v_colvals(v_null_reorder_n(n)) + 1;
				else
					v_col_len := v_colvals(v_null_reorder_n(n)) + 3;
				end if;
				--
				v_trailing_nullcol_len := 1;
				--
			end if;
			--
			v_null_reorder_row_len := v_null_reorder_row_len + v_col_len;
			--
			if in_debug_flag > 1 then
				--
				dbms_output.put_line('...'||rpad(v_null_reorder_clist(n),30,' ')||
					' = '||trim(to_char(v_col_len,'99,990'))||
					case when v_colvals(v_null_reorder_n(n)) is null then '(NULL)' else '' end);
				--
			end if;
			--
		end loop;
		--
		v_tot_null_reorder_row_len := v_tot_null_reorder_row_len + v_null_reorder_row_len;
		--
		if in_debug_flag > 0 then
			--
			dbms_output.put_line('#'||rpad(to_char(v_row_cnt),10,' ')||
				' curr='||trim(to_char(v_curr_row_len,'99,990'))||
				', after reorder='||trim(to_char(v_null_reorder_row_len,'99,990')));
			--
		end if;
		--
	end loop;
	--
	dbms_output.put_line(chr(10));
	dbms_output.put_line('=== Total Results ===');
	dbms_output.put_line('current avg_row_len = '||
			trim(to_char(v_tot_curr_row_len/case when v_row_cnt=0 then null else v_row_cnt end,'999,990.00')));
	dbms_output.put_line('NULL re-order avg_row_len = '||
			trim(to_char(v_tot_null_reorder_row_len/case when v_row_cnt=0 then null else v_row_cnt end,'999,990.00')));
	--
	v_errctx := 'dbms_sql.close_cursor';
	dbms_sql.close_cursor(c);
	--
exception
	--
	when others then
		v_errmsg := sqlerrm;
		raise_application_error(-20000, v_errctx||': '||v_errmsg);
	--
end carl; /* end of procedure carl */
/
show errors

spool off
set echo off feedback 6 timing off
