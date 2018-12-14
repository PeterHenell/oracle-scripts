CREATE OR REPLACE PROCEDURE loadlots7 (
   tab IN VARCHAR2)
IS
   -- 5/2003 Warrenville Move from package to local...
   TYPE empnolist IS VARRAY(1000) of emp.empno%TYPE;
   TYPE deptlist  IS VARRAY(1000) of emp.deptno%TYPE;
   TYPE enamelist IS VARRAY(1000) of emp.ename%TYPE;
   empnos empnolist;
   depts  deptlist; 
   enames enamelist;
BEGIN
   depts  := deptlist();
   enames := enamelist();
   empnos := empnolist();
   
   empnos.extend(1000);
   depts.extend(1000);
   enames.extend(1000);

   FOR i IN 1 .. 1000 loop
     empnos(i) := i;
     depts(i)  := GREATEST (10 * MOD (i,4), 10);
     enames(i) := 'Steven'||i;
   END LOOP;
   
   FORALL i IN empnos.FIRST .. empnos.LAST
	  EXECUTE IMMEDIATE
        'INSERT INTO ' || tab || ' (empno, deptno, ename)
           VALUES (:empno, :deptno, :ename)'
		USING empnos(i), depts(i), enames(i);
END;
/
