/*
|| Without cursor variables, need to write separate loops and 
|| reporting logic (in this case very simple) for each cursor.
*/
DECLARE   
   CURSOR bydept
   IS
      SELECT ename, deptno FROM emp ORDER BY deptno;

   CURSOR bysal
   IS
      SELECT ename, sal FROM emp ORDER BY sal;

   CURSOR fromdept
   IS
     SELECT dname, deptno FROM dept;

BEGIN
   OPEN bydept;
   LOOP
      FETCH bydept INTO bydept_rec;
      EXIT WHEN bydept%NOTFOUND;

      p.l (bydept_rec.ename, bydept_rec.deptno);
   END LOOP;
   CLOSE bydept;

   OPEN bysal;
   LOOP
      FETCH bysal INTO bysal_rec;
      EXIT WHEN bysal%NOTFOUND;

      p.l (bysal_rec.ename, bysal_rec.deptno);
   END LOOP;
   CLOSE bysal;

   OPEN fromdept;
   LOOP
      FETCH fromdept INTO fromdept_rec;
      EXIT WHEN fromdept%NOTFOUND;

      p.l (fromdept_rec.ename, fromdept_rec.deptno);
   END LOOP;
   CLOSE fromdept;

END;
/
