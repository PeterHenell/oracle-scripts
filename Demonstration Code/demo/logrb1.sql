declare
   function emprows return integer
   is
      retval integer;
   begin
      select count(*) into retval
        from emp;
      return retval;
   end;
begin
   plvexc.trc;
   plvlog.do_rollback;
   p.l ('before insert', emprows);
   insert into emp (empno, deptno)
   values (9090, 10);
   raise no_data_found;
exception
   when others
   then
      p.l ('before recngo', emprows );
      plvexc.recngo;
      p.l ('after recngo', emprows );
      rollback;
end;