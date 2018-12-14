CREATE OR REPLACE PROCEDURE showall
IS
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;

   empno_tab DBMS_SQL.NUMBER_TABLE;
   hiredate_tab DBMS_SQL.DATE_TABLE;
BEGIN
   DBMS_SQL.PARSE
     (cur, 'SELECT empno, hiredate FROM emp', DBMS_SQL.NATIVE);

   DBMS_SQL.DEFINE_ARRAY (cur, 1, empno_tab, 100, 1);
   DBMS_SQL.DEFINE_ARRAY (cur, 2, hiredate_tab, 100, 1);

   fdbk := DBMS_SQL.EXECUTE_AND_FETCH (cur);
   
   DBMS_SQL.COLUMN_VALUE (cur, 1, empno_tab);
   DBMS_SQL.COLUMN_VALUE (cur, 2, hiredate_tab);
   
   FOR rowind IN empno_tab.FIRST .. empno_tab.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE (empno_tab(rowind));
      DBMS_OUTPUT.PUT_LINE (hiredate_tab(rowind));
   END LOOP;
   
   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
