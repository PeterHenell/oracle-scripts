SELECT *
  FROM emp;

CREATE OR REPLACE PROCEDURE remove_emps_by_deptx (deptlist deptlist_t)
IS
BEGIN
   FORALL adept IN deptlist.FIRST .. deptlist.LAST
      DELETE FROM emp
            WHERE deptno IN deptlist (adept);
END;
/

DECLARE
   l   deptlist_t := deptlist_t (10, 20);
BEGIN
   remove_emps_by_deptx (l);
END;
/

SELECT *
  FROM emp;