CREATE OR REPLACE PROCEDURE loadlots5 (tab IN VARCHAR2)
IS
   cur      INTEGER                 := DBMS_SQL.open_cursor;
   fdbk     INTEGER;
   empnos   DBMS_SQL.number_table;
   depts    DBMS_SQL.number_table;
   enames   DBMS_SQL.varchar2_table;
BEGIN
   FOR i IN 1 .. 1000
   LOOP
      empnos (i) := i;
      depts (i) := GREATEST (10 * MOD (i, 4), 10);
      enames (i) := 'Steven' || i;
   END LOOP;

   DBMS_SQL.parse (cur,
      'INSERT INTO '
       || tab
       || ' (empno, deptno, ename) values (:empnos, :depts, :enames)',
      DBMS_SQL.native
   );
   DBMS_SQL.bind_array (cur, 'empnos', empnos);
   DBMS_SQL.bind_array (cur, 'depts', depts);
   DBMS_SQL.bind_array (cur, 'enames', enames);
   fdbk := DBMS_SQL.EXECUTE (cur);
   DBMS_SQL.close_cursor (cur);
END;
/
