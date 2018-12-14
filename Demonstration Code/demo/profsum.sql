Rem
Rem $Header: profsum.sql 13-apr-98.19:17:28 astocks Exp $
Rem
Rem profsum.sql
Rem
Rem  Copyright (c) Oracle Corporation 1998. All Rights Reserved.
Rem
Rem    NAME
Rem      profsum.sql
Rem
Rem    DESCRIPTION
Rem      Example of usage of profiler data. Various useful adhoc queries, and
Rem      calls to the prof_report_utilities package.
Rem
Rem    NOTES
Rem      You must connect before running this script. Some of the queries will
Rem      need to be modified for use outside of the of a demo, since they
Rem      explicity use 'SCOTT' as a user id.
Rem
Rem      Calls to the long reports can be commented out.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    astocks     06/26/98 - More queries
Rem    astocks     04/13/98 - Quick summary and rollup of profiler runs
Rem    astocks     04/13/98 - Created
Rem

/* Script to dump lots of reports from ordts long performance run */
set echo off
@profrep
set echo on
set serveroutput on
spool profsum.out

/* Clean out rollup results, and recreate */
truncate table plsql_profiler_line_rollup;
update plsql_profiler_units set total_instructions = 0;

execute prof_report_utilities.rollup_all_runs;

/* Total time */
select to_char(grand_total/1000000000, '999999.99') 
  as grand_total
  from plsql_profiler_grand_total;

/* Total time spent on each run */

select runid, substr(run_comment,1, 30) as run_comment, 
       run_total_time/1000000000 as seconds 
       from plsql_profiler_runs 
       where run_total_time > 0 
       order by runid asc;

/* Percentage of time in each module, for each run separately */

select p1.runid,
       substr(p2.run_comment, 1, 20) as run_comment,
       decode(p1.unit_name, '', '<anonymous>', substr(p1.unit_name,1, 20)) as unit_name, 
       TO_CHAR(p1.total_time/1000000000, '99999.99') as seconds, 
       TO_CHAR(100*p1.total_time/p2.run_total_time, '999.9') as percentage 
       from plsql_profiler_units p1, plsql_profiler_runs p2 
       where p1.runid=p2.runid and 
             p1.total_time > 0 and p2.run_total_time > 0 and  
             (p1.total_time/p2.run_total_time)  >= .01
        order by p1.runid asc, p1.total_time desc;

/* Percentage of time in each module, summarized across runs */

select decode(p1.unit_name, '', '<anonymous>', substr(p1.unit_name,1, 25)) as unit_name, 
       TO_CHAR(p1.total_time/1000000000, '99999.99') as seconds, 
       TO_CHAR(100*p1.total_time/p2.grand_total, '99999.99') as percentage 
       from plsql_profiler_units_cross_run p1, 
            plsql_profiler_grand_total p2 
       order by p1.total_time DESC;

/* Analyze min/max/average time anomalies */
select p1.runid, substr(p2.unit_name,1,25), 
       to_char(p1.line#,'9999') as line,
       p1.total_occur,
       to_char(p1.pc,'99999') as pc,
       to_char(p1.total_time/1000,'9999999.99') as microS, 
       to_char(p1.total_time/(1000*p1.total_occur),'9999999.99') as "Ave Micro",
       to_char(p1.min_time/1000,'9999999.99') as min_time, 
       to_char(p1.max_time/1000,'999999999.99') as max_time, 
       to_char(p1.max_time/p1.min_time,'999999.99') as "Max/min",
       p1.opcode,
       to_char(p1.total_time/(p1.total_occur*p1.min_time),'99999.99')as "Ave/min",
       p3.text
       from plsql_profiler_data p1, 
            plsql_profiler_units p2, 
            all_source p3
        where ((p1.total_time > 1000*(p1.total_occur*p1.min_time)) OR
                  (p1.total_time < (p1.total_occur*p1.min_time))) AND
                p1.runID=p2.runID and p2.unit_number = p1.unit_number AND
                ((p3.type='PACKAGE BODY') OR (p3.type = 'PROCEDURE')) and 
                p3.line = p1.line# and 
                (p3.owner = 'SCOTT')   AND 
                (p3.name=substr(p2.unit_name, 7))
        order by "Ave/min" asc;
/* Note that the field "p2.unit_name" will be of the form "user.unit"
   (e.g. "SCOTT.FOO"), whereas all_source stores these separately. 
   The test "(p3.name=substr(p2.unit_name, 7))" is comparing only the
   names. The "7" is the starting character of the name, and is 2 greater
   than the length of the username. */

/* Popular lines, each run separate */
select p1.runid as runid,
       to_char(p1.total_time/1000000000, '99999.9') as seconds, 
       p1.total_instructions, 
       decode(p2.unit_name, '', '<anonymous>', substr(p2.unit_name,1, 20)) as unit_name, 
       p1.line#, 
       p3.text 
  from plsql_profiler_line_rollup p1, 
       plsql_profiler_units p2, 
       all_source p3, plsql_profiler_grand_total p4 
  where (p1.total_time >= p4.grand_total/100) AND 
        p1.runID = p2.runid and 
        p2.unit_number=p1.unit_number and 
        p3.type='PACKAGE BODY' and 
        p3.owner = 'SCOTT' and 
        p3.line = p1.line# and 
        p3.name=substr(p2.unit_name, 8) 
  order by p1.total_time desc;

/* Most popular lines, summarize across all runs */
select to_char(p1.total_time/1000000000, '99999.9') as seconds, 
       p1.total_instructions, 
       decode(p1.unit_name, '', '<anonymous>', substr(p1.unit_name,1, 20)) as unit_name, 
       p1.line#, 
       p3.text 
  from plsql_profiler_lines_cross_run p1, 
       all_source p3, 
       plsql_profiler_grand_total p4
  where (p1.total_time >= p4.grand_total/1000) AND 
       ((p3.type='PACKAGE BODY') OR (p3.type = 'PROCEDURE')) and 
       p3.line = p1.line# and 
       (p3.owner = 'SCOTT') AND
       (p3.name=substr(p1.unit_name, 7))
  order by p1.total_time desc;


/* Get coverage information for each package body over all runs*/
execute prof_report_utilities.rollup_all_runs; 
select 
  p2.unit_name,
  count(p1.line#) as lines_executed,
  p2.lines_with_code as total_lines, 
  100*count(p1.line#)/p2.lines_with_code as covered_percentage
  from plsql_profiler_lines_cross_run p1,
       plsql_profiler_units_cross_run p2 
  where p1.unit_name like 'SCOTT.%' AND
        p2.unit_type = 11 AND
        p1.unit_name = p2.unit_name
  group by p2.unit_name, p2.lines_with_code; 

/* Full reports */ 
execute prof_report_utilities.Print_Detailed_Report;
execute prof_report_utilities.Print_Summarized_Report;



spool off
