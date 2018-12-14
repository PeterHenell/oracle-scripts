begin
   INSERT INTO emp (empno, ename, deptno, hiredate) 
      VALUES (222, 'steven', 10, SYSDATE+10);
   COMMIT;
END;
