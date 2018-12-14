DECLARE
   TYPE empcurtype IS REF CURSOR RETURN emp%ROWTYPE;
   TYPE anycurtype IS REF CURSOR;
   v anycurtype;
   r emp%ROWTYPE;
BEGIN
   OPEN v FOR SELECT * FROM emp;
   LOOP 
      FETCH v INTO r;
      EXIT WHEN v%NOTFOUND;
      p.l(r.ename); 
   END LOOP;
END;
/