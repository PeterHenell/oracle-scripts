DECLARE
   TYPE little_rec_t IS RECORD (
      empno number,
	  ename varchar2(100),
	  deptno number);
	  
 little_rec little_rec_t; 
BEGIN
   -- Copy a table using INSERT with record.
   BEGIN
      EXECUTE IMMEDIATE 'drop table emp_copy';
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   EXECUTE IMMEDIATE 'create table emp_copy as select * from emp where 1=2';

   FOR rec IN  (SELECT *
                  FROM emp)
   LOOP
      -- Notice that you do NOT put parens around the record.
	  INSERT INTO emp_copy
           VALUES rec; 
		   
      -- But if I specify a subset of columns, then I WILL have
	  -- to put parens around the record invocation. 
	  little_rec.empno := rec.empno;
	  little_rec.ename := rec.ename;
	  little_rec.deptno := rec.deptno;
	  INSERT INTO emp_copy (empno, ename, deptno)
           VALUES (little_rec);		   
   END LOOP;

   DBMS_OUTPUT.put_line (tabcount ('emp_copy'));
END;

/
