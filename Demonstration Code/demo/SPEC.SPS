create or replace PACKAGE analysis
IS
   FUNCTION avg_workload (dept_id IN INTEGER) RETURN NUMBER;
   FUNCTION workload (operator_id IN INTEGER) RETURN NUMBER;
   FUNCTION avg_numcalls (dept_id IN INTEGER) RETURN NUMBER;
END analysis;
/