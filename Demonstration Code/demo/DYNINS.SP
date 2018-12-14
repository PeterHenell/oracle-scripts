CREATE OR REPLACE PACKAGE mytables
IS
   TYPE number_table IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
   TYPE varchar2_table IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
END;
/
CREATE OR REPLACE PROCEDURE instab7 
   (empnotab IN mytables.number_table, 
    enametab IN mytables.varchar2_table)
IS   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
   totfdbk PLS_INTEGER := 0;
BEGIN      
   DBMS_SQL.PARSE (cur,
      'INSERT INTO emp (empno, ename) VALUES (:empno, :ename)',
      DBMS_SQL.NATIVE);

   FOR emprow IN empnotab.FIRST .. empnotab.LAST
   LOOP
      DBMS_SQL.BIND_VARIABLE (cur, 'empno', empnotab(emprow));
      DBMS_SQL.BIND_VARIABLE (cur, 'ename', enametab(emprow));
      fdbk := DBMS_SQL.EXECUTE (cur);
      totfdbk := totfdbk + fdbk;
   END LOOP;

   DBMS_OUTPUT.PUT_LINE ('Rows inserted: ' || TO_CHAR (totfdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
CREATE OR REPLACE PROCEDURE instab8 
   (empnotab IN DBMS_SQL.NUMBER_TABLE, enametab IN DBMS_SQL.VARCHAR2_TABLE)
IS   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
BEGIN 
   DBMS_SQL.PARSE (cur,
      'INSERT INTO emp (empno, ename) VALUES (:empno, :ename)',
      DBMS_SQL.NATIVE);

   DBMS_SQL.BIND_ARRAY (cur, 'empno', empnotab);
   DBMS_SQL.BIND_ARRAY (cur, 'ename', enametab);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows inserted: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
sho err
   
