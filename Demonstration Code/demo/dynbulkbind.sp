CREATE OR REPLACE PACKAGE arrayz
AS
   TYPE empnolist IS VARRAY ( 1000 ) OF emp.empno%TYPE;

   TYPE deptlist IS VARRAY ( 1000 ) OF emp.deptno%TYPE;

   TYPE enamelist IS VARRAY ( 1000 ) OF emp.ename%TYPE;

   empnos empnolist;
   depts deptlist;
   enames enamelist;
END;
/

BEGIN
   arrayz.empnos := arrayz.empnolist ( );
   arrayz.empnos.EXTEND ( 1000 );
   arrayz.depts := arrayz.deptlist ( );
   arrayz.depts.EXTEND ( 1000 );
   arrayz.enames := arrayz.enamelist ( );
   arrayz.enames.EXTEND ( 1000 );
END;
/

CREATE OR REPLACE PROCEDURE loadlots7 ( tab IN VARCHAR2 )
IS
BEGIN
   FOR i IN 1 .. 1000
   LOOP
      arrayz.empnos ( i ) := i;
      arrayz.depts ( i ) := GREATEST ( 10 * MOD ( i, 4 ), 10 );
      arrayz.enames ( i ) := 'Steven' || i;
   END LOOP;

   EXECUTE IMMEDIATE    '
     BEGIN
       FORALL i IN 1..1000
         INSERT INTO '
                     || tab
                     || ' (empno, deptno, ename)
           VALUES (arrayz.empnos(i), arrayz.depts(i), arrayz.enames(i));
     END;
   ';
END;
/
