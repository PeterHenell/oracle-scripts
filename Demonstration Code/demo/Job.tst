set serveroutput on

drop table emp2;

create table emp2 as select * from emp;

exec p.l (tabcount(user, 'emp2'));

create or replace procedure delemps is
begin
   delete from emp2;
   
   /*
   execute immediate 'drop table delemps_tab';
   execute immediate 'create table delemps_tab (x date)';
   */
end;
/
show errors

declare
i integer;
begin
   dbms_job.submit (i, 'begin delemps; end;', sysdate, 'sysdate+10/1440');
   p.l (i);
   commit;
end;
/

exec p.l (tabcount(user, 'emp2'));

exec dbms_lock.sleep (10);

exec p.l (tabcount(user, 'emp2'));

