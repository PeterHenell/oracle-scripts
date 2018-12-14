CREATE OR REPLACE PROCEDURE showall
IS
   cur INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk INTEGER;
   numrows INTEGER := 5;

   empno_tab DBMS_SQL.NUMBER_TABLE;
   hiredate_tab DBMS_SQL.DATE_TABLE;
BEGIN
   DBMS_SQL.PARSE
     (cur, 'SELECT empno, hiredate FROM emp', DBMS_SQL.NATIVE);

   DBMS_SQL.DEFINE_ARRAY (cur, 1, empno_tab, numrows, 1);
   DBMS_SQL.DEFINE_ARRAY (cur, 2, hiredate_tab, numrows, 1);

   fdbk := DBMS_SQL.EXECUTE (cur);
   LOOP
      p.l ('fetching again');
      fdbk := DBMS_SQL.FETCH_ROWS (cur);
   
      EXIT WHEN fdbk = 0;

      DBMS_SQL.COLUMN_VALUE (cur, 1, empno_tab);
      DBMS_SQL.COLUMN_VALUE (cur, 2, hiredate_tab);
   
      FOR rowind IN empno_tab.FIRST .. empno_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE (empno_tab(rowind));
         DBMS_OUTPUT.PUT_LINE (hiredate_tab(rowind));
      END LOOP;

      empno_tab.DELETE;
      hiredate_tab.DELETE;

      EXIT WHEN fdbk < numrows;

   END LOOP;

   DBMS_SQL.CLOSE_CURSOR (cur);
END;
/
