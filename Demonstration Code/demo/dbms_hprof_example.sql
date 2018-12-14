/*

Privileges Needed:

EXECUTE on DBMS_HPROF

*/

@intab_dbms_sql.sp

create or replace directory hprof_dir as 'c:/temp'
/

BEGIN
   DELETE FROM dbmshp_parent_child_info;

   DELETE FROM dbmshp_function_info;

   DELETE FROM dbmshp_runs;

   COMMIT;
END;
/

BEGIN
   dbms_hprof.start_profiling ('HPROF_DIR', 'intab_trace.txt');
   intab ('DEPARTMENTS');
   dbms_hprof.stop_profiling;
END;
/

CREATE OR REPLACE PACKAGE dbms_hprof_run
IS
   g_run_number   NUMBER;

   FUNCTION run_number
      RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY dbms_hprof_run
IS
   FUNCTION run_number
      RETURN NUMBER
   IS
   BEGIN
      RETURN g_run_number;
   END;
END;
/

BEGIN
   dbms_hprof_run.g_run_number :=
                           dbms_hprof.ANALYZE ('HPROF_DIR', 'intab_trace.txt');
END;
/

/* In OS

plshprof -output hprof intab_trace.txt

*/

SELECT runid, run_timestamp, total_elapsed_time, run_comment
  FROM dbmshp_runs
/

SELECT symbolid, owner, module, TYPE, FUNCTION, line#, namespace
  FROM dbmshp_function_info
/

SELECT FUNCTION, line#, namespace, subtree_elapsed_time
     , function_elapsed_time, calls
  FROM dbmshp_function_info
 WHERE runid = dbms_hprof_run.run_number
/

SELECT parentsymid, childsymid, subtree_elapsed_time, function_elapsed_time
     , calls
  FROM dbmshp_parent_child_info
 WHERE runid = dbms_hprof_run.run_number
/

SELECT     RPAD (' ', LEVEL * 2, ' ') || fi.owner || '.' || fi.module AS NAME
         , fi.FUNCTION, pci.subtree_elapsed_time, pci.function_elapsed_time
         , pci.calls
      FROM dbmshp_parent_child_info pci JOIN dbmshp_function_info fi
           ON pci.runid = fi.runid AND pci.childsymid = fi.symbolid
     WHERE pci.runid = dbms_hprof_run.run_number
CONNECT BY PRIOR childsymid = parentsymid
START WITH pci.parentsymid = 1
/