DECLARE
   e   DBMS_SQL.varchar2s;
   l   PLS_INTEGER;
BEGIN
   e (1) := 'a';
   e (2) := 'b';
   FORALL indx IN e.FIRST .. e.LAST
      EXECUTE IMMEDIATE 
      'BEGIN
         update employees set last_name = :1;
         update departments set department_name = :2;
       END;'
                  USING e (indx), e (indx);

   SELECT COUNT (*)
     INTO l
     FROM employees
    WHERE last_name <> 'b';

   p.l (l);
END;