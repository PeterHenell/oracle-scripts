DECLARE
   CURSOR join_cur
   IS
      SELECT E.deptno, ename, sal, total_salary
        FROM emp E, dept_salary DS
       WHERE E.deptno = DS.deptno
         AND sal = 
           (SELECT MAX (sal) 
              FROM emp E2
             WHERE E2.deptno = E.deptno)
       ORDER BY E.deptno, ename;

   CURSOR inline_cur
   IS
      SELECT E.deptno, ename, sal, total_salary
        FROM emp E, 
             (SELECT deptno, SUM (sal) total_salary 
                FROM emp
                GROUP BY deptno) DS
       WHERE E.deptno = DS.deptno
         AND sal = 
           (SELECT MAX (sal) 
              FROM emp E2
             WHERE E2.deptno = E.deptno)
       ORDER BY E.deptno, ename;

   CURSOR plsql_cur
   IS
      SELECT deptno, 
             ename, 
             sal, 
             totsal (deptno) totsal
        FROM emp
       WHERE sal = maxsal (deptno)
       ORDER BY deptno, ename;
 BEGIN
    sf_timer.start_timer;
    FOR rec IN join_cur
    LOOP
       p.l (rec.ename, rec.total_salary);
    END LOOP;
    sf_timer.show_elapsed_time ('View');

    sf_timer.start_timer;
    FOR rec IN inline_cur
    LOOP
       p.l (rec.ename, rec.total_salary);
    END LOOP;
    sf_timer.show_elapsed_time ('Inline');

    sf_timer.start_timer;
    FOR rec IN plsql_cur
    LOOP
       p.l (rec.ename, rec.totsal);
    END LOOP;
    sf_timer.show_elapsed_time ('Functions');
 END;
/
