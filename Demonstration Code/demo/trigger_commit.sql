CREATE OR REPLACE TRIGGER no_mut_err1
   AFTER insert OR update 
   ON emp FOR EACH ROW
DECLARE
   /* Utrecht 2000 */
   --PRAGMA AUTONOMOUS_TRANSACTION;
   t INTEGER;
BEGIN
   /* No more mutating table error for SELECTs! */ 
   select count(*) into t from emp;
   commit;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
END;
/
CREATE OR REPLACE TRIGGER no_mut_err2
   AFTER insert OR update 
   ON emp_copy FOR EACH ROW
DECLARE
   /* Utrecht 2000 */
   PRAGMA AUTONOMOUS_TRANSACTION;
   t INTEGER;
BEGIN
   update emp_copy set sal = sal where empno = 7369;
   commit;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
END;
/



