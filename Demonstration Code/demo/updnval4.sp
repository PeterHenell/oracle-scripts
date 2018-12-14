CREATE OR REPLACE PROCEDURE updsal 
   (ename_in IN emp.ename%TYPE,  sal_in IN emp.sal%TYPE)
IS   
   cur PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
   fdbk PLS_INTEGER;
	my_sql PLV.dbmaxvc2 :=
      'UPDATE employee SET salary = ' || sal_in || 
      ' WHERE last_name LIKE UPPER (''' || ename_in || ''')';
BEGIN 
   DBMS_SQL.PARSE (cur, my_sql, DBMS_SQL.NATIVE);

   fdbk := DBMS_SQL.EXECUTE (cur);

   DBMS_OUTPUT.PUT_LINE ('Rows updated: ' || TO_CHAR (fdbk));

   DBMS_SQL.CLOSE_CURSOR (cur);
EXCEPTION
   WHEN OTHERS
   THEN
      p.l (SQLERRM);
      p.l (my_sql);
      DBMS_SQL.CLOSE_CURSOR (cur);
END;
/