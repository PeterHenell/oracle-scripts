CREATE TYPE dlist_t AS TABLE OF INTEGER;
/

CREATE OR REPLACE PROCEDURE remove_emps_by_dept1 (deptlist dlist_t)
IS
BEGIN
   FOR adept IN deptlist.FIRST .. deptlist.LAST
   LOOP
      DELETE FROM emp
            WHERE deptno = deptlist (adept);
   END LOOP;
END remove_emps_by_dept1;
/

CREATE OR REPLACE PROCEDURE remove_emps_by_dept2 (deptlist dlist_t)
IS
   l_delete_string   VARCHAR2 (32767) := 'delete from emp where deptno in (';
BEGIN
   FOR adept IN deptlist.FIRST .. deptlist.LAST
   LOOP
      l_delete_string := l_delete_string || deptlist (adept) || ',';
   END LOOP;

   EXECUTE IMMEDIATE RTRIM (l_delete_string, ',') || ')';
END remove_emps_by_dept2;
/

CREATE OR REPLACE PROCEDURE remove_emps_by_dept3 (deptlist dlist_t)
IS
BEGIN
   FORALL adept IN deptlist.FIRST .. deptlist.LAST
      DELETE FROM emp
            WHERE deptno = deptlist (adept);
END remove_emps_by_dept3;
/

DECLARE
   l_deptlist   dlist_t := dlist_t ();
BEGIN
   NULL;
END;
/