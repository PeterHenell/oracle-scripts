drop table emp2;

create table emp2 as select * from emp;

create or replace procedure ughshow (str VARCHAR2)
is
   n number;
begin
   select count(*) into n from emp2;
   p.l (str, n);
end;
/

create or replace procedure ugh10 
is
  PRAGMA AUTONOMOUS_TRANSACTION;
begin
   delete from emp2 where deptno = 10;
   commit;
end;
/

create or replace procedure ugh20 
is
  PRAGMA AUTONOMOUS_TRANSACTION;
begin
   ugh10;
   ughshow ('after ugh10');
   rollback;
   ughshow ('after ugh10 rollback');
   delete from emp2 where deptno = 20;
   commit;
end;
/

DECLARE
   n number;
BEGIN
   ughshow ('before the action');
   ugh20;
   ughshow ('after ugh20');
   rollback;
   ughshow ('after ugh20 rollback');
END;
/

drop procedure ugh10;
drop procedure ugh20;
drop procedure ughshow;