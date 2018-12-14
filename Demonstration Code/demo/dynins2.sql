DECLARE
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;

   empnos DBMS_SQL.NUMBER_TABLE;
   deptnos DBMS_SQL.NUMBER_TABLE;
BEGIN
   empnos(1)  := 901; empnos(2) := 902;
   deptnos(10000) := 10; deptnos(20000) := 40;

   DBMS_SQL.PARSE (cur,
     'INSERT INTO emp (empno, deptno, sal) VALUES ' ||
     ' (:empnos, :deptnos, :onesal)',
     DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_ARRAY (cur, 'empnos', empnos, 1, 2);
   DBMS_SQL.BIND_ARRAY (cur, 'deptnos', deptnos, 10000, 20000);
   DBMS_SQL.BIND_VARIABLE (cur, 'onesal', 1000);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_SQL.CLOSE_CURSOR (cur);
END;                          
/