CREATE OR REPLACE TRIGGER add_row
   AFTER UPDATE  
   ON emp FOR EACH ROW
BEGIN
   INSERT INTO dept (deptno, dname) VALUES (:new.empno, :new.empno);
   IF :new.empno < 1000 THEN RAISE VALUE_ERROR; END IF;
END;
/


