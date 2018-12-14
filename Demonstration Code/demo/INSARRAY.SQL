DECLARE
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;

   empnos DBMS_SQL.NUMBER_TABLE;
   deptnos DBMS_SQL.NUMBER_TABLE;
BEGIN
   DBMS_SQL.PARSE (cur, 
      'INSERT INTO emp (empno, deptno, sal) ' ||
      '  VALUES (:empnos, :deptnos, :onesal)',
      DBMS_SQL.NATIVE);

   empnos(1)  := 901; empnos(2) := 902;
   deptnos(1000) := 10; deptnos(10000) := 40;
   DBMS_SQL.BIND_ARRAY (cur, 'empnos', empnos, 1, 2);
   DBMS_SQL.BIND_ARRAY (cur, 'deptnos', deptnos, 1000, 10000);
   DBMS_SQL.BIND_VARIABLE (cur, 'onesal', 1000);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_SQL.CLOSE_CURSOR (cur);
END;                           
/

select * from emp where empno between 900 and 905;
