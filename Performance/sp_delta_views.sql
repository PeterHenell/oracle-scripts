/**********************************************************************
 * File:	sp_delta_views.sql
 * Type:        SQL*Plus script
 * Author:      Tim Gorman (Evergreen Database Technologies, Inc.)
 * Date:        05Jan04
 *
 * Description:
 *
 *	SQL*Plus script containing DDL to create views that automatically
 *	calculate the "delta" or difference between adjacent samples of
 *	data gathered by the STATSPACK package.
 *
 *	Each of these views is named the same as the corresponding tables
 *	in the STATSPACK repository, except that the prefix of "STATS$"
 *	has been replaced by a prefix of "DELTA$".
 *
 *	Views are present for the following STATSPACK repository tables:
 *
 *		Table Name			View Name
 *		==========			=========
 *		STATS$BG_EVENT_SUMMARY		DELTA$BG_EVENT_SUMMARY
 *		STATS$BUFFER_POOL_STATISTICS	DELTA$BUFFER_POOL_STATISTICS
 *		STATS$DATABASE_INSTANCE		(data not cumulative)
 *		STATS$DB_CACHE_ADVICE		(data not cumulative)
 *		STATS$DLM_MISC			(data not cumulative)
 *		STATS$ENQUEUE_STAT		DELTA$ENQUEUE_STAT
 *		STATS$FILESTATXS		DELTA$FILESTATXS
 *		STATS$IDLE_EVENT		(data not cumulative)
 *		STATS$INSTANCE_RECOVERY		(data not cumulative)
 *		STATS$LATCH			DELTA$LATCH
 *		STATS$LATCH_CHILDREN		DELTA$LATCH_CHILDREN
 *		STATS$LATCH_MISSES_SUMMARY	DELTA$LATCH_MISSES_SUMMARY
 *		STATS$LATCH_PARENT		DELTA$LATCH_PARENT
 *		STATS$LEVEL_DESCRIPTION		(data not cumulative)
 *		STATS$LIBRARYCACHE		DELTA$LIBRARYCACHE
 *		STATS$PARAMETER			(data not cumulative)
 *		STATS$PGASTAT			DELTA$PGASTAT
 *		STATS$PGA_TARGET_ADVICE		(data not cumulative)
 *		STATS$RESOURCE_LIMIT		(data not cumulative)
 *		STATS$ROLLSTAT			DELTA$ROLLSTAT
 *		STATS$ROWCACHE_SUMMARY		DELTA$ROWCACHE_SUMMARY
 *		STATS$SEG_STAT			DELTA$SEG_STAT
 *		STATS$SEG_STAT_OBJ		(data not cumulative)
 *		STATS$SESSION_EVENT		DELTA$SESSION_EVENT
 *		STATS$SESSTAT			DELTA$SESSTAT
 *		STATS$SGA			(data not cumulative)
 *		STATS$SGASTAT			DELTA$SGASTAT
 *		STATS$SHARED_POOL_ADVICE	(data not cumulative)
 *		STATS$SNAPSHOT			(data not cumulative)
 *		STATS$SQLTEXT			(data not cumulative)
 *		STATS$SQL_PLAN			(data not cumulative)
 *		STATS$SQL_PLAN_USAGE		(data not cumulative)
 *		STATS$SQL_STATISTICS		(data not cumulative)
 *		STATS$SQL_SUMMARY		DELTA$SQL_SUMMARY
 *		STATS$SQL_WORKAREA_HISTOGRAM	(data not cumulative)
 *		STATS$STATSPACK_PARAMETER	(data not cumulative)
 *		STATS$SYSSTAT			DELTA$SYSSTAT
 *		STATS$SYSTEM_EVENT		DELTA$SYSTEM_EVENT
 *		STATS$TEMPSTATXS		DELTA$TEMPSTATXS
 *		STATS$UNDOSTAT			DELTA$UNDOSTAT
 *		STATS$WAITSTAT			DELTA$WAITSTAT
 *
 *	These views were created for Oracle9i STATSPACK;  if using
 *	Oracle8i STATSPACK, then the following tables do not exist and
 *	the corresponding view creations are expected to fail:
 *
 *		Table Name
 *		==========
 *		STATS$DB_CACHE_ADVICE
 *		STATS$PGASTAT
 *		STATS$PGA_TARGET_ADVICE
 *		STATS$SEG_STAT
 *		STATS$SEG_STAT_OBJ
 *		STATS$SHARED_POOL_ADVICE
 *		STATS$SQL_PLAN
 *		STATS$SQL_PLAN_USAGE
 *		STATS$SQL_STATISTICS
 *		STATS$SQL_WORKAREA_HISTOGRAM
 *		STATS$UNDOSTAT
 *
 *	However, for four other views, you'll need to make the following
 *	modifications to get them to create correctly in Oracle8i:
 *
 *	- in the creation of the view DELTA$ENQUEUE_STAT, change the
 *	  name of STATS$ENQUEUE_STAT to STATS$ENQUEUESTAT.  You can
 *	  change the name of the view as well, if you wish, but it is
 *	  not a requirement...
 *
 *	- in the creation of the view DELTA$BG_EVENT_SUMMARY, change
 *	  the name of the column TIME_WAITED_MICRO to TIME_WAITED
 *
 *	- in the creation of the view DELTA$SESSION_EVENT, change
 *	  the name of the column TIME_WAITED_MICRO to TIME_WAITED
 *
 *	- in the creation of the view DELTA$SYSTEM_EVENT, change
 *	  the name of the column TIME_WAITED_MICRO to TIME_WAITED
 *
 * Modifications:
 *********************************************************************/
set echo on feedback on timing on
spool sp_delta_views

create or replace view delta$bg_event_summary
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	EVENT,
	nvl(decode(greatest(TOTAL_WAITS, nvl(lag(TOTAL_WAITS) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TOTAL_WAITS, TOTAL_WAITS - lag(TOTAL_WAITS) over (partition by dbid, instance_number, event order by snap_id),
			TOTAL_WAITS), 0) TOTAL_WAITS,
	nvl(decode(greatest(TOTAL_TIMEOUTS, nvl(lag(TOTAL_TIMEOUTS) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TOTAL_TIMEOUTS, TOTAL_TIMEOUTS - lag(TOTAL_TIMEOUTS) over (partition by dbid, instance_number, event order by snap_id),
			TOTAL_TIMEOUTS), 0) TOTAL_TIMEOUTS,
	nvl(decode(greatest(TIME_WAITED_MICRO, nvl(lag(TIME_WAITED_MICRO) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TIME_WAITED_MICRO, TIME_WAITED_MICRO - lag(TIME_WAITED_MICRO) over (partition by dbid, instance_number, event order by snap_id),
			TIME_WAITED_MICRO), 0) TIME_WAITED_MICRO
from	stats$bg_event_summary;

create or replace view delta$buffer_pool_statistics
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	ID,
	NAME,
	BLOCK_SIZE,
	SET_MSIZE,
	CNUM_REPL,
	CNUM_WRITE,
	CNUM_SET,
	nvl(decode(greatest(BUF_GOT, nvl(lag(BUF_GOT) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   BUF_GOT, BUF_GOT - lag(BUF_GOT) over (partition by dbid, instance_number, id, name order by snap_id),
			BUF_GOT), 0) BUF_GOT,
	nvl(decode(greatest(SUM_WRITE, nvl(lag(SUM_WRITE) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   SUM_WRITE, SUM_WRITE - lag(SUM_WRITE) over (partition by dbid, instance_number, id, name order by snap_id),
			SUM_WRITE), 0) SUM_WRITE,
	nvl(decode(greatest(SUM_SCAN, nvl(lag(SUM_SCAN) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   SUM_SCAN, SUM_SCAN - lag(SUM_SCAN) over (partition by dbid, instance_number, id, name order by snap_id),
			SUM_SCAN), 0) SUM_SCAN,
	nvl(decode(greatest(FREE_BUFFER_WAIT, nvl(lag(FREE_BUFFER_WAIT) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   FREE_BUFFER_WAIT, FREE_BUFFER_WAIT - lag(FREE_BUFFER_WAIT) over (partition by dbid, instance_number, id, name order by snap_id),
			FREE_BUFFER_WAIT), 0) FREE_BUFFER_WAIT,
	nvl(decode(greatest(WRITE_COMPLETE_WAIT, nvl(lag(WRITE_COMPLETE_WAIT) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   WRITE_COMPLETE_WAIT, WRITE_COMPLETE_WAIT - lag(WRITE_COMPLETE_WAIT) over (partition by dbid, instance_number, id, name order by snap_id),
			WRITE_COMPLETE_WAIT), 0) WRITE_COMPLETE_WAIT,
	nvl(decode(greatest(BUFFER_BUSY_WAIT, nvl(lag(BUFFER_BUSY_WAIT) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   BUFFER_BUSY_WAIT, BUFFER_BUSY_WAIT - lag(BUFFER_BUSY_WAIT) over (partition by dbid, instance_number, id, name order by snap_id),
			BUFFER_BUSY_WAIT), 0) BUFFER_BUSY_WAIT,
	nvl(decode(greatest(FREE_BUFFER_INSPECTED, nvl(lag(FREE_BUFFER_INSPECTED) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   FREE_BUFFER_INSPECTED, FREE_BUFFER_INSPECTED - lag(FREE_BUFFER_INSPECTED) over (partition by dbid, instance_number, id, name order by snap_id),
			FREE_BUFFER_INSPECTED), 0) FREE_BUFFER_INSPECTED,
	nvl(decode(greatest(DIRTY_BUFFERS_INSPECTED, nvl(lag(DIRTY_BUFFERS_INSPECTED) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   DIRTY_BUFFERS_INSPECTED, DIRTY_BUFFERS_INSPECTED - lag(DIRTY_BUFFERS_INSPECTED) over (partition by dbid, instance_number, id, name order by snap_id),
			DIRTY_BUFFERS_INSPECTED), 0) DIRTY_BUFFERS_INSPECTED,
	nvl(decode(greatest(DB_BLOCK_CHANGE, nvl(lag(DB_BLOCK_CHANGE) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   DB_BLOCK_CHANGE, DB_BLOCK_CHANGE - lag(DB_BLOCK_CHANGE) over (partition by dbid, instance_number, id, name order by snap_id),
			DB_BLOCK_CHANGE), 0) DB_BLOCK_CHANGE,
	nvl(decode(greatest(DB_BLOCK_GETS, nvl(lag(DB_BLOCK_GETS) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   DB_BLOCK_GETS, DB_BLOCK_GETS - lag(DB_BLOCK_GETS) over (partition by dbid, instance_number, id, name order by snap_id),
			DB_BLOCK_GETS), 0) DB_BLOCK_GETS,
	nvl(decode(greatest(CONSISTENT_GETS, nvl(lag(CONSISTENT_GETS) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   CONSISTENT_GETS, CONSISTENT_GETS - lag(CONSISTENT_GETS) over (partition by dbid, instance_number, id, name order by snap_id),
			CONSISTENT_GETS), 0) CONSISTENT_GETS,
	nvl(decode(greatest(PHYSICAL_READS, nvl(lag(PHYSICAL_READS) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   PHYSICAL_READS, PHYSICAL_READS - lag(PHYSICAL_READS) over (partition by dbid, instance_number, id, name order by snap_id),
			PHYSICAL_READS), 0) PHYSICAL_READS,
	nvl(decode(greatest(PHYSICAL_WRITES, nvl(lag(PHYSICAL_WRITES) over (partition by dbid, instance_number, id, name order by snap_id),0)),
		   PHYSICAL_WRITES, PHYSICAL_WRITES - lag(PHYSICAL_WRITES) over (partition by dbid, instance_number, id, name order by snap_id),
			PHYSICAL_WRITES), 0) PHYSICAL_WRITES
from	stats$buffer_pool_statistics;

create or replace view delta$enqueue_stat
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	EQ_TYPE,
	nvl(decode(greatest(TOTAL_REQ#, nvl(lag(TOTAL_REQ#) over (partition by dbid, instance_number, eq_type order by snap_id),0)),
		   TOTAL_REQ#, TOTAL_REQ# - lag(TOTAL_REQ#) over (partition by dbid, instance_number, eq_type order by snap_id),
			TOTAL_REQ#), 0) TOTAL_REQ#,
	nvl(decode(greatest(TOTAL_WAIT#, nvl(lag(TOTAL_WAIT#) over (partition by dbid, instance_number, eq_type order by snap_id),0)),
		   TOTAL_WAIT#, TOTAL_WAIT# - lag(TOTAL_WAIT#) over (partition by dbid, instance_number, eq_type order by snap_id),
			TOTAL_WAIT#), 0) TOTAL_WAIT#,
	nvl(decode(greatest(SUCC_REQ#, nvl(lag(SUCC_REQ#) over (partition by dbid, instance_number, eq_type order by snap_id),0)),
		   SUCC_REQ#, SUCC_REQ# - lag(SUCC_REQ#) over (partition by dbid, instance_number, eq_type order by snap_id),
			SUCC_REQ#), 0) SUCC_REQ#,
	nvl(decode(greatest(FAILED_REQ#, nvl(lag(FAILED_REQ#) over (partition by dbid, instance_number, eq_type order by snap_id),0)),
		   FAILED_REQ#, FAILED_REQ# - lag(FAILED_REQ#) over (partition by dbid, instance_number, eq_type order by snap_id),
			FAILED_REQ#), 0) FAILED_REQ#,
	nvl(decode(greatest(CUM_WAIT_TIME, nvl(lag(CUM_WAIT_TIME) over (partition by dbid, instance_number, eq_type order by snap_id),0)),
		   CUM_WAIT_TIME, CUM_WAIT_TIME - lag(CUM_WAIT_TIME) over (partition by dbid, instance_number, eq_type order by snap_id),
			CUM_WAIT_TIME), 0) CUM_WAIT_TIME
from	stats$enqueue_stat;

create or replace view delta$filestatxs
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	TSNAME,
	FILENAME,
	nvl(decode(greatest(PHYRDS, nvl(lag(PHYRDS) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   PHYRDS, PHYRDS - lag(PHYRDS) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			PHYRDS), 0) PHYRDS,
	nvl(decode(greatest(PHYWRTS, nvl(lag(PHYWRTS) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   PHYWRTS, PHYWRTS - lag(PHYWRTS) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			PHYWRTS), 0) PHYWRTS,
	nvl(decode(greatest(SINGLEBLKRDS, nvl(lag(SINGLEBLKRDS) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   SINGLEBLKRDS, SINGLEBLKRDS - lag(SINGLEBLKRDS) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			SINGLEBLKRDS), 0) SINGLEBLKRDS,
	READTIM,
	WRITETIM,
	SINGLEBLKRDTIM,
	nvl(decode(greatest(PHYBLKRD, nvl(lag(PHYBLKRD) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   PHYBLKRD, PHYBLKRD - lag(PHYBLKRD) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			PHYBLKRD), 0) PHYBLKRD,
	nvl(decode(greatest(PHYBLKWRT, nvl(lag(PHYBLKWRT) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   PHYBLKWRT, PHYBLKWRT - lag(PHYBLKWRT) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			PHYBLKWRT), 0) PHYBLKWRT,
	nvl(decode(greatest(WAIT_COUNT, nvl(lag(WAIT_COUNT) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   WAIT_COUNT, WAIT_COUNT - lag(WAIT_COUNT) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			WAIT_COUNT), 0) WAIT_COUNT,
	nvl(decode(greatest(TIME, nvl(lag(TIME) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   TIME, TIME - lag(TIME) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			TIME), 0) TIME
from	stats$filestatxs;

create or replace view delta$latch
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	NAME,
	LATCH#,
	LEVEL#,
	nvl(decode(greatest(GETS, nvl(lag(GETS) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   GETS, GETS - lag(GETS) over (partition by dbid, instance_number, name, latch# order by snap_id),
			GETS), 0) GETS,
	nvl(decode(greatest(MISSES, nvl(lag(MISSES) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   MISSES, MISSES - lag(MISSES) over (partition by dbid, instance_number, name, latch# order by snap_id),
			MISSES), 0) MISSES,
	nvl(decode(greatest(SLEEPS, nvl(lag(SLEEPS) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   SLEEPS, SLEEPS - lag(SLEEPS) over (partition by dbid, instance_number, name, latch# order by snap_id),
			SLEEPS), 0) SLEEPS,
	nvl(decode(greatest(IMMEDIATE_GETS, nvl(lag(IMMEDIATE_GETS) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   IMMEDIATE_GETS, IMMEDIATE_GETS - lag(IMMEDIATE_GETS) over (partition by dbid, instance_number, name, latch# order by snap_id),
			IMMEDIATE_GETS), 0) IMMEDIATE_GETS,
	nvl(decode(greatest(IMMEDIATE_MISSES, nvl(lag(IMMEDIATE_MISSES) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   IMMEDIATE_MISSES, IMMEDIATE_MISSES - lag(IMMEDIATE_MISSES) over (partition by dbid, instance_number, name, latch# order by snap_id),
			IMMEDIATE_MISSES), 0) IMMEDIATE_MISSES,
	nvl(decode(greatest(SPIN_GETS, nvl(lag(SPIN_GETS) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   SPIN_GETS, SPIN_GETS - lag(SPIN_GETS) over (partition by dbid, instance_number, name, latch# order by snap_id),
			SPIN_GETS), 0) SPIN_GETS,
	nvl(decode(greatest(SLEEP1, nvl(lag(SLEEP1) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   SLEEP1, SLEEP1 - lag(SLEEP1) over (partition by dbid, instance_number, name, latch# order by snap_id),
			SLEEP1), 0) SLEEP1,
	nvl(decode(greatest(SLEEP2, nvl(lag(SLEEP2) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   SLEEP2, SLEEP2 - lag(SLEEP2) over (partition by dbid, instance_number, name, latch# order by snap_id),
			SLEEP2), 0) SLEEP2,
	nvl(decode(greatest(SLEEP3, nvl(lag(SLEEP3) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   SLEEP3, SLEEP3 - lag(SLEEP3) over (partition by dbid, instance_number, name, latch# order by snap_id),
			SLEEP3), 0) SLEEP3,
	nvl(decode(greatest(SLEEP4, nvl(lag(SLEEP4) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   SLEEP4, SLEEP4 - lag(SLEEP4) over (partition by dbid, instance_number, name, latch# order by snap_id),
			SLEEP4), 0) SLEEP4,
	nvl(decode(greatest(WAIT_TIME, nvl(lag(WAIT_TIME) over (partition by dbid, instance_number, name, latch# order by snap_id),0)),
		   WAIT_TIME, WAIT_TIME - lag(WAIT_TIME) over (partition by dbid, instance_number, name, latch# order by snap_id),
			WAIT_TIME), 0) WAIT_TIME
from	stats$latch;

create or replace view delta$latch_children
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	LATCH#,
	CHILD#,
	nvl(decode(greatest(GETS, nvl(lag(GETS) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   GETS, GETS - lag(GETS) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			GETS), 0) GETS,
	nvl(decode(greatest(MISSES, nvl(lag(MISSES) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   MISSES, MISSES - lag(MISSES) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			MISSES), 0) MISSES,
	nvl(decode(greatest(SLEEPS, nvl(lag(SLEEPS) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   SLEEPS, SLEEPS - lag(SLEEPS) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			SLEEPS), 0) SLEEPS,
	nvl(decode(greatest(IMMEDIATE_GETS, nvl(lag(IMMEDIATE_GETS) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   IMMEDIATE_GETS, IMMEDIATE_GETS - lag(IMMEDIATE_GETS) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			IMMEDIATE_GETS), 0) IMMEDIATE_GETS,
	nvl(decode(greatest(IMMEDIATE_MISSES, nvl(lag(IMMEDIATE_MISSES) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   IMMEDIATE_MISSES, IMMEDIATE_MISSES - lag(IMMEDIATE_MISSES) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			IMMEDIATE_MISSES), 0) IMMEDIATE_MISSES,
	nvl(decode(greatest(SPIN_GETS, nvl(lag(SPIN_GETS) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   SPIN_GETS, SPIN_GETS - lag(SPIN_GETS) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			SPIN_GETS), 0) SPIN_GETS,
	nvl(decode(greatest(SLEEP1, nvl(lag(SLEEP1) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   SLEEP1, SLEEP1 - lag(SLEEP1) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			SLEEP1), 0) SLEEP1,
	nvl(decode(greatest(SLEEP2, nvl(lag(SLEEP2) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   SLEEP2, SLEEP2 - lag(SLEEP2) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			SLEEP2), 0) SLEEP2,
	nvl(decode(greatest(SLEEP3, nvl(lag(SLEEP3) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   SLEEP3, SLEEP3 - lag(SLEEP3) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			SLEEP3), 0) SLEEP3,
	nvl(decode(greatest(SLEEP4, nvl(lag(SLEEP4) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   SLEEP4, SLEEP4 - lag(SLEEP4) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			SLEEP4), 0) SLEEP4,
	nvl(decode(greatest(WAIT_TIME, nvl(lag(WAIT_TIME) over (partition by dbid, instance_number, latch#, child# order by snap_id),0)),
		   WAIT_TIME, WAIT_TIME - lag(WAIT_TIME) over (partition by dbid, instance_number, latch#, child# order by snap_id),
			WAIT_TIME), 0) WAIT_TIME
from	stats$latch_children;

create or replace view delta$latch_misses_summary
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	PARENT_NAME,
	WHERE_IN_CODE,
	nvl(decode(greatest(NWFAIL_COUNT, nvl(lag(NWFAIL_COUNT) over (partition by dbid, instance_number, parent_name, where_in_code order by snap_id),0)),
		   NWFAIL_COUNT, NWFAIL_COUNT - lag(NWFAIL_COUNT) over (partition by dbid, instance_number, parent_name, where_in_code order by snap_id),
			NWFAIL_COUNT), 0) NWFAIL_COUNT,
	nvl(decode(greatest(SLEEP_COUNT, nvl(lag(SLEEP_COUNT) over (partition by dbid, instance_number, parent_name, where_in_code order by snap_id),0)),
		   SLEEP_COUNT, SLEEP_COUNT - lag(SLEEP_COUNT) over (partition by dbid, instance_number, parent_name, where_in_code order by snap_id),
			SLEEP_COUNT), 0) SLEEP_COUNT,
	nvl(decode(greatest(WTR_SLP_COUNT, nvl(lag(WTR_SLP_COUNT) over (partition by dbid, instance_number, parent_name, where_in_code order by snap_id),0)),
		   WTR_SLP_COUNT, WTR_SLP_COUNT - lag(WTR_SLP_COUNT) over (partition by dbid, instance_number, parent_name, where_in_code order by snap_id),
			WTR_SLP_COUNT), 0) WTR_SLP_COUNT
from	stats$latch_misses_summary;

create or replace view delta$latch_parent
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	LATCH#,
	LEVEL#,
	nvl(decode(greatest(GETS, nvl(lag(GETS) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   GETS, GETS - lag(GETS) over (partition by dbid, instance_number, latch# order by snap_id),
			GETS), 0) GETS,
	nvl(decode(greatest(MISSES, nvl(lag(MISSES) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   MISSES, MISSES - lag(MISSES) over (partition by dbid, instance_number, latch# order by snap_id),
			MISSES), 0) MISSES,
	nvl(decode(greatest(SLEEPS, nvl(lag(SLEEPS) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   SLEEPS, SLEEPS - lag(SLEEPS) over (partition by dbid, instance_number, latch# order by snap_id),
			SLEEPS), 0) SLEEPS,
	nvl(decode(greatest(IMMEDIATE_GETS, nvl(lag(IMMEDIATE_GETS) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   IMMEDIATE_GETS, IMMEDIATE_GETS - lag(IMMEDIATE_GETS) over (partition by dbid, instance_number, latch# order by snap_id),
			IMMEDIATE_GETS), 0) IMMEDIATE_GETS,
	nvl(decode(greatest(IMMEDIATE_MISSES, nvl(lag(IMMEDIATE_MISSES) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   IMMEDIATE_MISSES, IMMEDIATE_MISSES - lag(IMMEDIATE_MISSES) over (partition by dbid, instance_number, latch# order by snap_id),
			IMMEDIATE_MISSES), 0) IMMEDIATE_MISSES,
	nvl(decode(greatest(SPIN_GETS, nvl(lag(SPIN_GETS) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   SPIN_GETS, SPIN_GETS - lag(SPIN_GETS) over (partition by dbid, instance_number, latch# order by snap_id),
			SPIN_GETS), 0) SPIN_GETS,
	nvl(decode(greatest(SLEEP1, nvl(lag(SLEEP1) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   SLEEP1, SLEEP1 - lag(SLEEP1) over (partition by dbid, instance_number, latch# order by snap_id),
			SLEEP1), 0) SLEEP1,
	nvl(decode(greatest(SLEEP2, nvl(lag(SLEEP2) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   SLEEP2, SLEEP2 - lag(SLEEP2) over (partition by dbid, instance_number, latch# order by snap_id),
			SLEEP2), 0) SLEEP2,
	nvl(decode(greatest(SLEEP3, nvl(lag(SLEEP3) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   SLEEP3, SLEEP3 - lag(SLEEP3) over (partition by dbid, instance_number, latch# order by snap_id),
			SLEEP3), 0) SLEEP3,
	nvl(decode(greatest(SLEEP4, nvl(lag(SLEEP4) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   SLEEP4, SLEEP4 - lag(SLEEP4) over (partition by dbid, instance_number, latch# order by snap_id),
			SLEEP4), 0) SLEEP4,
	nvl(decode(greatest(WAIT_TIME, nvl(lag(WAIT_TIME) over (partition by dbid, instance_number, latch# order by snap_id),0)),
		   WAIT_TIME, WAIT_TIME - lag(WAIT_TIME) over (partition by dbid, instance_number, latch# order by snap_id),
			WAIT_TIME), 0) WAIT_TIME
from	stats$latch_parent;

create or replace view delta$librarycache
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	NAMESPACE,
	nvl(decode(greatest(GETS, nvl(lag(GETS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   GETS, GETS - lag(GETS) over (partition by dbid, instance_number, namespace order by snap_id),
			GETS), 0) GETS,
	nvl(decode(greatest(GETHITS, nvl(lag(GETHITS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   GETHITS, GETHITS - lag(GETHITS) over (partition by dbid, instance_number, namespace order by snap_id),
			GETHITS), 0) GETHITS,
	nvl(decode(greatest(PINS, nvl(lag(PINS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   PINS, PINS - lag(PINS) over (partition by dbid, instance_number, namespace order by snap_id),
			PINS), 0) PINS,
	nvl(decode(greatest(PINHITS, nvl(lag(PINHITS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   PINHITS, PINHITS - lag(PINHITS) over (partition by dbid, instance_number, namespace order by snap_id),
			PINHITS), 0) PINHITS,
	nvl(decode(greatest(RELOADS, nvl(lag(RELOADS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   RELOADS, RELOADS - lag(RELOADS) over (partition by dbid, instance_number, namespace order by snap_id),
			RELOADS), 0) RELOADS,
	nvl(decode(greatest(INVALIDATIONS, nvl(lag(INVALIDATIONS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   INVALIDATIONS, INVALIDATIONS - lag(INVALIDATIONS) over (partition by dbid, instance_number, namespace order by snap_id),
			INVALIDATIONS), 0) INVALIDATIONS,
	nvl(decode(greatest(DLM_LOCK_REQUESTS, nvl(lag(DLM_LOCK_REQUESTS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   DLM_LOCK_REQUESTS, DLM_LOCK_REQUESTS - lag(DLM_LOCK_REQUESTS) over (partition by dbid, instance_number, namespace order by snap_id),
			DLM_LOCK_REQUESTS), 0) DLM_LOCK_REQUESTS,
	nvl(decode(greatest(DLM_PIN_REQUESTS, nvl(lag(DLM_PIN_REQUESTS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   DLM_PIN_REQUESTS, DLM_PIN_REQUESTS - lag(DLM_PIN_REQUESTS) over (partition by dbid, instance_number, namespace order by snap_id),
			DLM_PIN_REQUESTS), 0) DLM_PIN_REQUESTS,
	nvl(decode(greatest(DLM_PIN_RELEASES, nvl(lag(DLM_PIN_RELEASES) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   DLM_PIN_RELEASES, DLM_PIN_RELEASES - lag(DLM_PIN_RELEASES) over (partition by dbid, instance_number, namespace order by snap_id),
			DLM_PIN_RELEASES), 0) DLM_PIN_RELEASES,
	nvl(decode(greatest(DLM_INVALIDATION_REQUESTS, nvl(lag(DLM_INVALIDATION_REQUESTS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   DLM_INVALIDATION_REQUESTS, DLM_INVALIDATION_REQUESTS - lag(DLM_INVALIDATION_REQUESTS) over (partition by dbid, instance_number, namespace order by snap_id),
			DLM_INVALIDATION_REQUESTS), 0) DLM_INVALIDATION_REQUESTS,
	nvl(decode(greatest(DLM_INVALIDATIONS, nvl(lag(DLM_INVALIDATIONS) over (partition by dbid, instance_number, namespace order by snap_id),0)),
		   DLM_INVALIDATIONS, DLM_INVALIDATIONS - lag(DLM_INVALIDATIONS) over (partition by dbid, instance_number, namespace order by snap_id),
			DLM_INVALIDATIONS), 0) DLM_INVALIDATIONS
from	stats$librarycache;

create or replace view delta$pgastat
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	NAME,
	nvl(decode(greatest(VALUE, nvl(lag(VALUE) over (partition by dbid, instance_number, name order by snap_id),0)),
		   VALUE, VALUE - lag(VALUE) over (partition by dbid, instance_number, name order by snap_id),
			VALUE), 0) VALUE
from	stats$pgastat;

create or replace view delta$rollstat
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	USN,
	EXTENTS,
	RSSIZE,
	nvl(decode(greatest(WRITES, nvl(lag(WRITES) over (partition by dbid, instance_number, usn order by snap_id),0)),
		   WRITES, WRITES - lag(WRITES) over (partition by dbid, instance_number, usn order by snap_id),
			WRITES), 0) WRITES,
	XACTS,
	nvl(decode(greatest(GETS, nvl(lag(GETS) over (partition by dbid, instance_number, usn order by snap_id),0)),
		   GETS, GETS - lag(GETS) over (partition by dbid, instance_number, usn order by snap_id),
			GETS), 0) GETS,
	nvl(decode(greatest(WAITS, nvl(lag(WAITS) over (partition by dbid, instance_number, usn order by snap_id),0)),
		   WAITS, WAITS - lag(WAITS) over (partition by dbid, instance_number, usn order by snap_id),
			WAITS), 0) WAITS,
	OPTSIZE,
	HWMSIZE,
	nvl(decode(greatest(SHRINKS, nvl(lag(SHRINKS) over (partition by dbid, instance_number, usn order by snap_id),0)),
		   SHRINKS, SHRINKS - lag(SHRINKS) over (partition by dbid, instance_number, usn order by snap_id),
			SHRINKS), 0) SHRINKS,
	nvl(decode(greatest(WRAPS, nvl(lag(WRAPS) over (partition by dbid, instance_number, usn order by snap_id),0)),
		   WRAPS, WRAPS - lag(WRAPS) over (partition by dbid, instance_number, usn order by snap_id),
			WRAPS), 0) WRAPS,
	nvl(decode(greatest(EXTENDS, nvl(lag(EXTENDS) over (partition by dbid, instance_number, usn order by snap_id),0)),
		   EXTENDS, EXTENDS - lag(EXTENDS) over (partition by dbid, instance_number, usn order by snap_id),
			EXTENDS), 0) EXTENDS,
	AVESHRINK,
	AVEACTIVE
from	stats$rollstat;

create or replace view delta$rowcache_summary
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	PARAMETER,
	nvl(decode(greatest(TOTAL_USAGE, nvl(lag(TOTAL_USAGE) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   TOTAL_USAGE, TOTAL_USAGE - lag(TOTAL_USAGE) over (partition by dbid, instance_number, parameter order by snap_id),
			TOTAL_USAGE), 0) TOTAL_USAGE,
	nvl(decode(greatest(USAGE, nvl(lag(USAGE) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   USAGE, USAGE - lag(USAGE) over (partition by dbid, instance_number, parameter order by snap_id),
			USAGE), 0) USAGE,
	nvl(decode(greatest(GETS, nvl(lag(GETS) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   GETS, GETS - lag(GETS) over (partition by dbid, instance_number, parameter order by snap_id),
			GETS), 0) GETS,
	nvl(decode(greatest(GETMISSES, nvl(lag(GETMISSES) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   GETMISSES, GETMISSES - lag(GETMISSES) over (partition by dbid, instance_number, parameter order by snap_id),
			GETMISSES), 0) GETMISSES,
	nvl(decode(greatest(SCANS, nvl(lag(SCANS) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   SCANS, SCANS - lag(SCANS) over (partition by dbid, instance_number, parameter order by snap_id),
			SCANS), 0) SCANS,
	nvl(decode(greatest(SCANMISSES, nvl(lag(SCANMISSES) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   SCANMISSES, SCANMISSES - lag(SCANMISSES) over (partition by dbid, instance_number, parameter order by snap_id),
			SCANMISSES), 0) SCANMISSES,
	nvl(decode(greatest(SCANCOMPLETES, nvl(lag(SCANCOMPLETES) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   SCANCOMPLETES, SCANCOMPLETES - lag(SCANCOMPLETES) over (partition by dbid, instance_number, parameter order by snap_id),
			SCANCOMPLETES), 0) SCANCOMPLETES,
	nvl(decode(greatest(MODIFICATIONS, nvl(lag(MODIFICATIONS) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   MODIFICATIONS, MODIFICATIONS - lag(MODIFICATIONS) over (partition by dbid, instance_number, parameter order by snap_id),
			MODIFICATIONS), 0) MODIFICATIONS,
	nvl(decode(greatest(FLUSHES, nvl(lag(FLUSHES) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   FLUSHES, FLUSHES - lag(FLUSHES) over (partition by dbid, instance_number, parameter order by snap_id),
			FLUSHES), 0) FLUSHES,
	nvl(decode(greatest(DLM_REQUESTS, nvl(lag(DLM_REQUESTS) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   DLM_REQUESTS, DLM_REQUESTS - lag(DLM_REQUESTS) over (partition by dbid, instance_number, parameter order by snap_id),
			DLM_REQUESTS), 0) DLM_REQUESTS,
	nvl(decode(greatest(DLM_CONFLICTS, nvl(lag(DLM_CONFLICTS) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   DLM_CONFLICTS, DLM_CONFLICTS - lag(DLM_CONFLICTS) over (partition by dbid, instance_number, parameter order by snap_id),
			DLM_CONFLICTS), 0) DLM_CONFLICTS,
	nvl(decode(greatest(DLM_RELEASES, nvl(lag(DLM_RELEASES) over (partition by dbid, instance_number, parameter order by snap_id),0)),
		   DLM_RELEASES, DLM_RELEASES - lag(DLM_RELEASES) over (partition by dbid, instance_number, parameter order by snap_id),
			DLM_RELEASES), 0) DLM_RELEASES
from	stats$rowcache_summary;

create or replace view delta$seg_stat
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	DATAOBJ#,
	OBJ#,
	TS#,
	nvl(decode(greatest(LOGICAL_READS, nvl(lag(LOGICAL_READS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   LOGICAL_READS, LOGICAL_READS - lag(LOGICAL_READS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			LOGICAL_READS), 0) LOGICAL_READS,
	nvl(decode(greatest(BUFFER_BUSY_WAITS, nvl(lag(BUFFER_BUSY_WAITS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   BUFFER_BUSY_WAITS, BUFFER_BUSY_WAITS - lag(BUFFER_BUSY_WAITS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			BUFFER_BUSY_WAITS), 0) BUFFER_BUSY_WAITS,
	nvl(decode(greatest(DB_BLOCK_CHANGES, nvl(lag(DB_BLOCK_CHANGES) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   DB_BLOCK_CHANGES, DB_BLOCK_CHANGES - lag(DB_BLOCK_CHANGES) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			DB_BLOCK_CHANGES), 0) DB_BLOCK_CHANGES,
	nvl(decode(greatest(PHYSICAL_READS, nvl(lag(PHYSICAL_READS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   PHYSICAL_READS, PHYSICAL_READS - lag(PHYSICAL_READS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			PHYSICAL_READS), 0) PHYSICAL_READS,
	nvl(decode(greatest(PHYSICAL_WRITES, nvl(lag(PHYSICAL_WRITES) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   PHYSICAL_WRITES, PHYSICAL_WRITES - lag(PHYSICAL_WRITES) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			PHYSICAL_WRITES), 0) PHYSICAL_WRITES,
	nvl(decode(greatest(DIRECT_PHYSICAL_READS, nvl(lag(DIRECT_PHYSICAL_READS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   DIRECT_PHYSICAL_READS, DIRECT_PHYSICAL_READS - lag(DIRECT_PHYSICAL_READS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			DIRECT_PHYSICAL_READS), 0) DIRECT_PHYSICAL_READS,
	nvl(decode(greatest(DIRECT_PHYSICAL_WRITES, nvl(lag(DIRECT_PHYSICAL_WRITES) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   DIRECT_PHYSICAL_WRITES, DIRECT_PHYSICAL_WRITES - lag(DIRECT_PHYSICAL_WRITES) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			DIRECT_PHYSICAL_WRITES), 0) DIRECT_PHYSICAL_WRITES,
	nvl(decode(greatest(GLOBAL_CACHE_CR_BLOCKS_SERVED, nvl(lag(GLOBAL_CACHE_CR_BLOCKS_SERVED) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   GLOBAL_CACHE_CR_BLOCKS_SERVED, GLOBAL_CACHE_CR_BLOCKS_SERVED - lag(GLOBAL_CACHE_CR_BLOCKS_SERVED) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			GLOBAL_CACHE_CR_BLOCKS_SERVED), 0) GLOBAL_CACHE_CR_BLOCKS_SERVED,
	nvl(decode(greatest(GLOBAL_CACHE_CU_BLOCKS_SERVED, nvl(lag(GLOBAL_CACHE_CU_BLOCKS_SERVED) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   GLOBAL_CACHE_CU_BLOCKS_SERVED, GLOBAL_CACHE_CU_BLOCKS_SERVED - lag(GLOBAL_CACHE_CU_BLOCKS_SERVED) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			GLOBAL_CACHE_CU_BLOCKS_SERVED), 0) GLOBAL_CACHE_CU_BLOCKS_SERVED,
	nvl(decode(greatest(ITL_WAITS, nvl(lag(ITL_WAITS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   ITL_WAITS, ITL_WAITS - lag(ITL_WAITS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			ITL_WAITS), 0) ITL_WAITS,
	nvl(decode(greatest(ROW_LOCK_WAITS, nvl(lag(ROW_LOCK_WAITS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),0)),
		   ROW_LOCK_WAITS, ROW_LOCK_WAITS - lag(ROW_LOCK_WAITS) over (partition by dbid, instance_number, dataobj#, obj#, ts# order by snap_id),
			ROW_LOCK_WAITS), 0) ROW_LOCK_WAITS
from	stats$seg_stat;

create or replace view delta$session_event
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	EVENT,
	nvl(decode(greatest(TOTAL_WAITS, nvl(lag(TOTAL_WAITS) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TOTAL_WAITS, TOTAL_WAITS - lag(TOTAL_WAITS) over (partition by dbid, instance_number, event order by snap_id),
			TOTAL_WAITS), 0) TOTAL_WAITS,
	nvl(decode(greatest(TOTAL_TIMEOUTS, nvl(lag(TOTAL_TIMEOUTS) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TOTAL_TIMEOUTS, TOTAL_TIMEOUTS - lag(TOTAL_TIMEOUTS) over (partition by dbid, instance_number, event order by snap_id),
			TOTAL_TIMEOUTS), 0) TOTAL_TIMEOUTS,
	nvl(decode(greatest(TIME_WAITED_MICRO, nvl(lag(TIME_WAITED_MICRO) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TIME_WAITED_MICRO, TIME_WAITED_MICRO - lag(TIME_WAITED_MICRO) over (partition by dbid, instance_number, event order by snap_id),
			TIME_WAITED_MICRO), 0) TIME_WAITED_MICRO,
	MAX_WAIT
from	stats$session_event;

create or replace view delta$sesstat
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	STATISTIC#,
	nvl(decode(greatest(VALUE, nvl(lag(VALUE) over (partition by dbid, instance_number, statistic# order by snap_id),0)),
		   VALUE, VALUE - lag(VALUE) over (partition by dbid, instance_number, statistic# order by snap_id),
			VALUE), 0) VALUE
from	stats$sesstat;

create or replace view delta$sql_summary
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	TEXT_SUBSET,
	SQL_TEXT,
	SHARABLE_MEM,
	nvl(decode(greatest(SORTS, nvl(lag(SORTS) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   SORTS, SORTS - lag(SORTS) over (partition by dbid, instance_number, hash_value order by snap_id),
			SORTS), 0) SORTS,
	MODULE,
	nvl(decode(greatest(LOADED_VERSIONS, nvl(lag(LOADED_VERSIONS) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   LOADED_VERSIONS, LOADED_VERSIONS - lag(LOADED_VERSIONS) over (partition by dbid, instance_number, hash_value order by snap_id),
			LOADED_VERSIONS), 0) LOADED_VERSIONS,
	nvl(decode(greatest(FETCHES, nvl(lag(FETCHES) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   FETCHES, FETCHES - lag(FETCHES) over (partition by dbid, instance_number, hash_value order by snap_id),
			FETCHES), 0) FETCHES,
	nvl(decode(greatest(EXECUTIONS, nvl(lag(EXECUTIONS) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   EXECUTIONS, EXECUTIONS - lag(EXECUTIONS) over (partition by dbid, instance_number, hash_value order by snap_id),
			EXECUTIONS), 0) EXECUTIONS,
	nvl(decode(greatest(LOADS, nvl(lag(LOADS) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   LOADS, LOADS - lag(LOADS) over (partition by dbid, instance_number, hash_value order by snap_id),
			LOADS), 0) LOADS,
	nvl(decode(greatest(INVALIDATIONS, nvl(lag(INVALIDATIONS) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   INVALIDATIONS, INVALIDATIONS - lag(INVALIDATIONS) over (partition by dbid, instance_number, hash_value order by snap_id),
			INVALIDATIONS), 0) INVALIDATIONS,
	nvl(decode(greatest(PARSE_CALLS, nvl(lag(PARSE_CALLS) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   PARSE_CALLS, PARSE_CALLS - lag(PARSE_CALLS) over (partition by dbid, instance_number, hash_value order by snap_id),
			PARSE_CALLS), 0) PARSE_CALLS,
	nvl(decode(greatest(DISK_READS, nvl(lag(DISK_READS) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   DISK_READS, DISK_READS - lag(DISK_READS) over (partition by dbid, instance_number, hash_value order by snap_id),
			DISK_READS), 0) DISK_READS,
	nvl(decode(greatest(BUFFER_GETS, nvl(lag(BUFFER_GETS) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   BUFFER_GETS, BUFFER_GETS - lag(BUFFER_GETS) over (partition by dbid, instance_number, hash_value order by snap_id),
			BUFFER_GETS), 0) BUFFER_GETS,
	nvl(decode(greatest(ROWS_PROCESSED, nvl(lag(ROWS_PROCESSED) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   ROWS_PROCESSED, ROWS_PROCESSED - lag(ROWS_PROCESSED) over (partition by dbid, instance_number, hash_value order by snap_id),
			ROWS_PROCESSED), 0) ROWS_PROCESSED,
	COMMAND_TYPE,
	ADDRESS,
	HASH_VALUE,
	nvl(decode(greatest(VERSION_COUNT, nvl(lag(VERSION_COUNT) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   VERSION_COUNT, VERSION_COUNT - lag(VERSION_COUNT) over (partition by dbid, instance_number, hash_value order by snap_id),
			VERSION_COUNT), 0) VERSION_COUNT,
	nvl(decode(greatest(CPU_TIME, nvl(lag(CPU_TIME) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   CPU_TIME, CPU_TIME - lag(CPU_TIME) over (partition by dbid, instance_number, hash_value order by snap_id),
			CPU_TIME), 0) CPU_TIME,
	nvl(decode(greatest(ELAPSED_TIME, nvl(lag(ELAPSED_TIME) over (partition by dbid, instance_number, hash_value order by snap_id),0)),
		   ELAPSED_TIME, ELAPSED_TIME - lag(ELAPSED_TIME) over (partition by dbid, instance_number, hash_value order by snap_id),
			ELAPSED_TIME), 0) ELAPSED_TIME,
	OUTLINE_SID,
	OUTLINE_CATEGORY,
	CHILD_LATCH
from	stats$sql_summary;

create or replace view delta$sysstat
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	STATISTIC#,
	NAME,
	nvl(decode(greatest(VALUE, nvl(lag(VALUE) over (partition by dbid, instance_number, statistic# order by snap_id),0)),
		   VALUE, VALUE - lag(VALUE) over (partition by dbid, instance_number, statistic# order by snap_id),
			VALUE), 0) VALUE
from	stats$sysstat;

create or replace view delta$system_event
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	EVENT,
	nvl(decode(greatest(TOTAL_WAITS, nvl(lag(TOTAL_WAITS) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TOTAL_WAITS, TOTAL_WAITS - lag(TOTAL_WAITS) over (partition by dbid, instance_number, event order by snap_id),
			TOTAL_WAITS), 0) TOTAL_WAITS,
	nvl(decode(greatest(TOTAL_TIMEOUTS, nvl(lag(TOTAL_TIMEOUTS) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TOTAL_TIMEOUTS, TOTAL_TIMEOUTS - lag(TOTAL_TIMEOUTS) over (partition by dbid, instance_number, event order by snap_id),
			TOTAL_TIMEOUTS), 0) TOTAL_TIMEOUTS,
	nvl(decode(greatest(TIME_WAITED_MICRO, nvl(lag(TIME_WAITED_MICRO) over (partition by dbid, instance_number, event order by snap_id),0)),
		   TIME_WAITED_MICRO, TIME_WAITED_MICRO - lag(TIME_WAITED_MICRO) over (partition by dbid, instance_number, event order by snap_id),
			TIME_WAITED_MICRO), 0) TIME_WAITED_MICRO
from	stats$system_event;

create or replace view delta$tempstatxs
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	TSNAME,
	FILENAME,
	nvl(decode(greatest(PHYRDS, nvl(lag(PHYRDS) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   PHYRDS, PHYRDS - lag(PHYRDS) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			PHYRDS), 0) PHYRDS,
	nvl(decode(greatest(PHYWRTS, nvl(lag(PHYWRTS) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   PHYWRTS, PHYWRTS - lag(PHYWRTS) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			PHYWRTS), 0) PHYWRTS,
	nvl(decode(greatest(SINGLEBLKRDS, nvl(lag(SINGLEBLKRDS) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   SINGLEBLKRDS, SINGLEBLKRDS - lag(SINGLEBLKRDS) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			SINGLEBLKRDS), 0) SINGLEBLKRDS,
	READTIM,
	WRITETIM,
	SINGLEBLKRDTIM,
	nvl(decode(greatest(PHYBLKRD, nvl(lag(PHYBLKRD) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   PHYBLKRD, PHYBLKRD - lag(PHYBLKRD) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			PHYBLKRD), 0) PHYBLKRD,
	nvl(decode(greatest(PHYBLKWRT, nvl(lag(PHYBLKWRT) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   PHYBLKWRT, PHYBLKWRT - lag(PHYBLKWRT) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			PHYBLKWRT), 0) PHYBLKWRT,
	nvl(decode(greatest(WAIT_COUNT, nvl(lag(WAIT_COUNT) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   WAIT_COUNT, WAIT_COUNT - lag(WAIT_COUNT) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			WAIT_COUNT), 0) WAIT_COUNT,
	nvl(decode(greatest(TIME, nvl(lag(TIME) over (partition by dbid, instance_number, tsname, filename order by snap_id),0)),
		   TIME, TIME - lag(TIME) over (partition by dbid, instance_number, tsname, filename order by snap_id),
			TIME), 0) TIME
from	stats$tempstatxs;

create or replace view delta$undostat
as
select	BEGIN_TIME,
	END_TIME,
	DBID,
	INSTANCE_NUMBER,
	SNAP_ID,
	UNDOTSN,
	UNDOBLKS,
	nvl(decode(greatest(TXNCOUNT, nvl(lag(TXNCOUNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   TXNCOUNT, TXNCOUNT - lag(TXNCOUNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			TXNCOUNT), 0) TXNCOUNT,
	MAXQUERYLEN,
	MAXCONCURRENCY,
	nvl(decode(greatest(UNXPSTEALCNT, nvl(lag(UNXPSTEALCNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   UNXPSTEALCNT, UNXPSTEALCNT - lag(UNXPSTEALCNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			UNXPSTEALCNT), 0) UNXPSTEALCNT,
	nvl(decode(greatest(UNXPBLKRELCNT, nvl(lag(UNXPBLKRELCNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   UNXPBLKRELCNT, UNXPBLKRELCNT - lag(UNXPBLKRELCNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			UNXPBLKRELCNT), 0) UNXPBLKRELCNT,
	nvl(decode(greatest(UNXPBLKREUCNT, nvl(lag(UNXPBLKREUCNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   UNXPBLKREUCNT, UNXPBLKREUCNT - lag(UNXPBLKREUCNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			UNXPBLKREUCNT), 0) UNXPBLKREUCNT,
	nvl(decode(greatest(EXPSTEALCNT, nvl(lag(EXPSTEALCNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   EXPSTEALCNT, EXPSTEALCNT - lag(EXPSTEALCNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			EXPSTEALCNT), 0) EXPSTEALCNT,
	nvl(decode(greatest(EXPBLKRELCNT, nvl(lag(EXPBLKRELCNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   EXPBLKRELCNT, EXPBLKRELCNT - lag(EXPBLKRELCNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			EXPBLKRELCNT), 0) EXPBLKRELCNT,
	nvl(decode(greatest(EXPBLKREUCNT, nvl(lag(EXPBLKREUCNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   EXPBLKREUCNT, EXPBLKREUCNT - lag(EXPBLKREUCNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			EXPBLKREUCNT), 0) EXPBLKREUCNT,
	nvl(decode(greatest(SSOLDERRCNT, nvl(lag(SSOLDERRCNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   SSOLDERRCNT, SSOLDERRCNT - lag(SSOLDERRCNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			SSOLDERRCNT), 0) SSOLDERRCNT,
	nvl(decode(greatest(NOSPACEERRCNT, nvl(lag(NOSPACEERRCNT) over (partition by dbid, instance_number, undotsn order by snap_id),0)),
		   NOSPACEERRCNT, NOSPACEERRCNT - lag(NOSPACEERRCNT) over (partition by dbid, instance_number, undotsn order by snap_id),
			NOSPACEERRCNT), 0) NOSPACEERRCNT
from	stats$undostat;

create or replace view delta$waitstat
as
select	SNAP_ID,
	DBID,
	INSTANCE_NUMBER,
	CLASS,
	nvl(decode(greatest(WAIT_COUNT, nvl(lag(WAIT_COUNT) over (partition by dbid, instance_number, class order by snap_id),0)),
		   WAIT_COUNT, WAIT_COUNT - lag(WAIT_COUNT) over (partition by dbid, instance_number, class order by snap_id),
			WAIT_COUNT), 0) WAIT_COUNT,
	nvl(decode(greatest(TIME, nvl(lag(TIME) over (partition by dbid, instance_number, class order by snap_id),0)),
		   TIME, TIME - lag(TIME) over (partition by dbid, instance_number, class order by snap_id),
			TIME), 0) TIME
from	stats$waitstat;

spool off
