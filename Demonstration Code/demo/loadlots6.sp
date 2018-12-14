CREATE OR REPLACE PACKAGE arrayz as
   TYPE empnolist IS VARRAY(1000) of emp.empno%TYPE;
   TYPE deptlist  IS VARRAY(1000) of emp.deptno%TYPE;
   TYPE enamelist IS VARRAY(1000) of emp.ename%TYPE;
   empnos empnolist;
   depts  deptlist; 
   enames enamelist;
END;
/
CREATE OR REPLACE PROCEDURE loadlots6 (
   tab IN VARCHAR2)
IS
BEGIN
   arrayz.depts  := arrayz.deptlist();
   arrayz.enames := arrayz.enamelist();
   arrayz.empnos := arrayz.empnolist();
   
   arrayz.empnos.extend(1000);
   arrayz.depts.extend(1000);
   arrayz.enames.extend(1000);

   FOR i IN 1 .. 1000 loop
     arrayz.empnos(i) := i;
     arrayz.depts(i)  := GREATEST (10 * MOD (i,4), 10);
     arrayz.enames(i) := 'Steven'||i;
   END LOOP;
   
   EXECUTE IMMEDIATE '
     BEGIN
       FORALL i IN 1..1000
         INSERT INTO ' || tab || ' (empno, deptno, ename)
           VALUES (arrayz.empnos(i), arrayz.depts(i), arrayz.enames(i));
     END;
   ';
END;
/
